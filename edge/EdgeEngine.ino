
#include <time.h>
#include <EdgeEngine_library.h>
#include <Wire.h>
#include <vector>
#include <string>
#include <max32664.h>

using std::vector;
using std::string;

#define RESET_PIN 04
#define MFIO_PIN 02
#define RAWDATA_BUFFLEN 250

max32664 MAX32664(RESET_PIN, MFIO_PIN, RAWDATA_BUFFLEN);

sample *physiologicalSample = NULL;
vector<sample*> samplesVect;


const char* ssidWifi = "elioslab";
const char* passWifi = "elio$lab";

edgine* Edge;
connection* Connection; //Wrapper for the wifi connection


/**
 * setup
 */
void setup() {

  Serial.begin(57600);
 
  Wire.begin();

  loadAlgomodeParameters();
  
  
  int result = MAX32664.hubBegin();
  if (result == CMD_SUCCESS){
    Serial.println("Sensorhub begin!");
  }else{
    //stay here.
    while(1){
      Serial.println("Could not communicate with the sensor!");
      Serial.println("please make proper connections");
      delay(5000);
    }
  }

  bool ret = MAX32664.startBPTcalibration();
  while(!ret){

    delay(10000);
    Serial.println("failed calib, please retsart");
    ret = MAX32664.startBPTcalibration();
  }
  delay(1000);

  Serial.println("start in estimation mode");
  ret = MAX32664.configAlgoInEstimationMode();
  while(!ret){

    Serial.println("failed est mode");
    ret = MAX32664.configAlgoInEstimationMode();
    delay(10000);
  }
  
  
  Serial.println("Getting the device ready..");
  
  //setup connection
  Connection = connection::getInstance();
  Connection->setupConnection(ssidWifi, passWifi);


  options opts;
  opts.username = "body-monitor-username";
  opts.password = "body-monitor-password";
  opts.tenant = "body-monitor";
  //route
  opts.url = "https://students.measurify.org";
  opts.ver = "v1";
  opts.login = "login";
  opts.devs = "devices";
  opts.scps = "scripts";
  opts.measurements = "measurements";
  opts.info= "info";
  opts.issues= "issues";
  //Edgine identifiers
  opts.thing = "mario.rossi";
  opts.device = "body-monitor";
  opts.id = "body-monitor";
  
  //initialize Edge engine
  Edge=edgine::getInstance();
  Edge->init(opts);
  
}

void loop() {
  
  physiologicalSample = new sample("physiological-state");
  physiologicalSample->startDate = Edge->Api->getActualDate();
  physiologicalSample->endDate = physiologicalSample->startDate;
  physiologicalSample->sizeOfSamples = Edge->getItems();
  physiologicalSample->myArray.assign(physiologicalSample->sizeOfSamples, 0);

  uint8_t num_samples = MAX32664.readSamples();

  if(num_samples){

    Serial.print("sys = ");
    Serial.print(MAX32664.max32664Output.sys);
    physiologicalSample->myArray[0]= MAX32664.max32664Output.sys;
    Serial.print(", dia = ");
    Serial.print(MAX32664.max32664Output.dia);
    physiologicalSample->myArray[1]= MAX32664.max32664Output.dia;
    Serial.print(", hr = ");
    Serial.print(MAX32664.max32664Output.hr);
    physiologicalSample->myArray[2]= MAX32664.max32664Output.hr;
    Serial.print(" spo2 = ");
    Serial.println(MAX32664.max32664Output.spo2);
    physiologicalSample->myArray[3]= MAX32664.max32664Output.spo2;
  }
  delay(100);

  samplesVect.push_back(physiologicalSample);

  
  Edge->evaluate(samplesVect);
  
  samplesVect.clear(); // after evaluated all samples delete them

  delete physiologicalSample;
  physiologicalSample = NULL;
  
 
}


void mfioInterruptHndlr(){
  //Serial.println("i");
}

void enableInterruptPin(){
  
  attachInterrupt(digitalPinToInterrupt(MAX32664.mfioPin), mfioInterruptHndlr, FALLING);

}

void loadAlgomodeParameters(){

  algomodeInitialiser algoParameters;

  algoParameters.calibValSys[0] = 120;
  algoParameters.calibValSys[1] = 122;
  algoParameters.calibValSys[2] = 125;

  algoParameters.calibValDia[0] = 80;
  algoParameters.calibValDia[1] = 81;
  algoParameters.calibValDia[2] = 82;

  algoParameters.spo2CalibCoefA = 1.5958422;
  algoParameters.spo2CalibCoefB = -34.659664;
  algoParameters.spo2CalibCoefC = 112.68987;

  MAX32664.loadAlgorithmParameters(&algoParameters);
}