# Agile_Data_Code_Proyecto_Pasos_Realizados

## Downloading Data

Once the server comes up, download the data and you are ready to go. First change directory into the `practica_big_data_2019` directory.

```
cd practica_big_data_2019
```
Now download the data.

For the [Realtime Predictive Analytics](http://datasyndrome.com/video)  run: 

```
resources/download_data.sh
```
## Installation

You need to install each component included in the architecture. 
The following list includes some links with the installation procedure for each component:

 - [Intellij](https://www.jetbrains.com/help/idea/installation-guide.html) (jdk_1.8)
 - [Pyhton3](https://realpython.com/installing-python/) (Suggested version 3.7) 
 - [PIP](https://ubunlog.com/pip-instalacion-conceptos-basicos-ubuntu-20-04/)
 - [SBT](https://www.scala-sbt.org/1.x/docs/Installing-sbt-on-Linux.html) 
 - [MongoDB](https://www.mongodb.com/docs/v4.2/tutorial/install-mongodb-on-ubuntu/)
 - [Spark](https://archive.apache.org/dist/spark/) (Mandatory version 3.1.2)
 - [Scala](https://docs.scala-lang.org/getting-started/index.html#using-the-scala-installer-recommended-way)(Suggested version 2.12)
 - [Zookeeper](https://howtoinstall.co/es/zookeeper)
 - [Kafka](https://hevodata.com/blog/how-to-install-kafka-on-ubuntu/)
 
 ### Install python libraries
 
 ```
  pip install -r requirements.txt
 ```
 ### Start Zookeeper
 
 Open a console and go to the downloaded Kafka directory and run:
 
 ```
   ~/kafka/bin/zookeeper-server-start.sh config/zookeeper.properties
  ```
  ### Start Kafka
  
  Open a console and go to the downloaded Kafka directory and run:
  
  ```
    ~/kafka/bin/kafka-server-start.sh config/server.properties 
   ```
   open a new console in teh same directory and create a new topic :
  ```
      ~/kafka/bin/kafka-topics.sh \
        --create \
        --zookeeper localhost:2181 \
        --replication-factor 1 \
        --partitions 1 \
        --topic flight_delay_classification_request
   ```
   You should see the following message:
  ```
    Created topic "flight_delay_classification_request".
  ```
   You can send an echo:
  ```
       echo "Asignatura FBID" | ~/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic flight_delay_classification_request > /dev/null
  
  ```
  Output:
  ```
    flight_delay_classification_request
  ```
  (Optional) You can oen a new console with a consumer in order to see the messeges sent to that topic
  ```
 ~/kafka/bin/kafka-console-consumer.sh \
      --bootstrap-server localhost:9092 \
      --topic flight_delay_classification_request \
      --from-beginning
  ```
  ## Import the distance records to MongoDB
  Check if you have Mongo up and running:
  ```
  1.- sudo systemctl start mongod
  2.- service mongod status
  3.- sudo systemctl enable mongod
  ```
  Output:
  ```
  mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; disabled; vendor preset: 
     Active: active (running) since Tue 2019-10-01 14:58:53 CEST; 2h 11min ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 7816 (mongod)
     CGroup: /system.slice/mongod.service
             ??????7816 /usr/bin/mongod --config /etc/mongod.conf
  
  oct 01 14:58:53 amunoz systemd[1]: Started MongoDB Database Server.
  ```
  Run the import_distances.sh script in practica_big_data_2019 directory:
  ```
  ./resources/import_distances.sh
  ```
  Output:
  ```
  2019-10-01T17:06:46.957+0200	connected to: mongodb://localhost/
  2019-10-01T17:06:47.035+0200	4696 document(s) imported successfully. 0 document(s) failed to import.
  MongoDB shell version v4.2.0
  connecting to: mongodb://127.0.0.1:27017/agile_data_science?compressors=disabled&gssapiServiceName=mongodb
  Implicit session: session { "id" : UUID("9bda4bb6-5727-4e91-8855-71db2b818232") }
  MongoDB server version: 4.2.0
  {
  	"createdCollectionAutomatically" : false,
  	"numIndexesBefore" : 1,
  	"numIndexesAfter" : 2,
  	"ok" : 1
  }

  ```
  ## Train and Save de the model with PySpark mllib
  In a console go to the base directory of the cloned repo, then go to the `practica_big_data_2019` directory
  ```
    cd practica_big_data_2019
  ```
  Set in root/.profile the `JAVA_HOME` env variable with teh path of java installation directory, for example:
  ```
    export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
  ```
  Set in root/.profile the `SPARK_HOME` env variable with teh path of your Spark installation folder, for example:
  ```
    export SPARK_HOME=/opt/spark
  ```
  Now, execute the script `train_spark_mllib_model.py`
  ```
      python3 resources/train_spark_mllib_model.py .
  ```
  As result, some files will be saved in the `models` folder 
  
  ```
  ls ../models
  
  ```   
  ## Run Flight Predictor
  First, you need to change the base_paht val in the MakePrediction scala class,
  change that val for the path where you clone repo is placed:
  ```
    val base_path= "/home/user/Desktop/practica_big_data_2019"
    
  ``` 
  Then run the code using Intellij or spark-submit with their respective arguments. 
  
Please, note that in order to use spark-submit you first need to compile the code and build a JAR file using sbt in flight_prediction directory: 
  ```
  1.- sbt compile
  2.- sbt run 
  3.- In another terminal: sbt package
  ```
Also, when running the spark-submit command form the "root", you have to add at least these two packages with the --packages option: (1 PUNTO)

  
Ingreso al siguiente directorio:

  ```shell
  
root@fbid-1:~# cd /opt/spark/sbin/
  ``` 
Iniciar master:
  ```shell
./start-master.sh -h 0.0.0.0
  ``` 
Iniciar worker:

  ```shell
./start-worker.sh spark://127.0.0.1:7077

spark-submit   --master spark://127.0.0.1:7077 --deploy-mode cluster  /home/jchavezz/Desktop/practica_big_data_2019/flight_prediction/target/scala-2.12/flight_prediction_2.12-0.1.jar --packages org.mongodb.spark:mongo-spark-connector_2.12:3.0.1,org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.2
     
  ``` 
   Be carefull with the packages version because if you are using another version of spark, kafka or mongo you have to choose the correspondent version to your installation. This packages work with Spark 3.1.2, kafka_2.12-3.1.2 and mongo superior to 2.6
  
  ## Start the prediction request Web Application
  
  Set the `PROJECT_HOME` env variable in root/.profile with teh path of you cloned repository, for example:
   ```
  export PROJECT_HOME=/home/user/Desktop/practica_big_data_2019
   ```
  Go to the `web` directory under `resources` and execute the flask web application file `predict_flask.py`:
  ```
  cd practica_big_data_2019/resources/web
  python3 predict_flask.py
  
  ```
  Now, visit http://localhost:5000/flights/delays/predict_kafka and, for fun, open the JavaScript console. Enter a nonzero departure delay, an ISO-formatted date (I used 2016-12-25, which was in the future at the time I was writing this), a valid carrier code (use AA or DL if you don???t know one), an origin and destination (my favorite is ATL ??? SFO), and a valid flight number (e.g., 1519), and hit Submit. Watch the debug output in the JavaScript console as the client polls for data from the response endpoint at /flights/delays/predict/classify_realtime/response/.
  
  Quickly switch windows to your Spark console. Within 10 seconds, the length we???ve configured of a minibatch, you should see something like the following:
  
  ## Check the predictions records inserted in MongoDB
  ```
   $ mongo
   > use use agile_data_science;
   >db.flight_delay_classification_response.find();
  
  ```
  You must have a similar output as:
  
  ```
  { "_id" : ObjectId("5d8dcb105e8b5622696d6f2e"), "Origin" : "ATL", "DayOfWeek" : 6, "DayOfYear" : 360, "DayOfMonth" : 25, "Dest" : "SFO", "DepDelay" : 290, "Timestamp" : ISODate("2019-09-27T08:40:48.175Z"), "FlightDate" : ISODate("2016-12-24T23:00:00Z"), "Carrier" : "AA", "UUID" : "8e90da7e-63f5-45f9-8f3d-7d948120e5a2", "Distance" : 2139, "Route" : "ATL-SFO", "Prediction" : 3 }
  { "_id" : ObjectId("5d8dcba85e8b562d1d0f9cb8"), "Origin" : "ATL", "DayOfWeek" : 6, "DayOfYear" : 360, "DayOfMonth" : 25, "Dest" : "SFO", "DepDelay" : 291, "Timestamp" : ISODate("2019-09-27T08:43:20.222Z"), "FlightDate" : ISODate("2016-12-24T23:00:00Z"), "Carrier" : "AA", "UUID" : "d3e44ea5-d42c-4874-b5f7-e8a62b006176", "Distance" : 2139, "Route" : "ATL-SFO", "Prediction" : 3 }
  { "_id" : ObjectId("5d8dcbe05e8b562d1d0f9cba"), "Origin" : "ATL", "DayOfWeek" : 6, "DayOfYear" : 360, "DayOfMonth" : 25, "Dest" : "SFO", "DepDelay" : 5, "Timestamp" : ISODate("2019-09-27T08:44:16.432Z"), "FlightDate" : ISODate("2016-12-24T23:00:00Z"), "Carrier" : "AA", "UUID" : "a153dfb1-172d-4232-819c-8f3687af8600", "Distance" : 2139, "Route" : "ATL-SFO", "Prediction" : 1 }


```


[<img src="images/PROYECTO_1.jpeg">]

[<img src="images/PROYECTO_2.jpeg">]



### Train the model with Apache Airflow (1 PUNTO)

- The version of Apache Airflow used is the 2.1.4 and it is installed with pip. For development it uses SQLite as database but it is not recommended for production. For the laboratory SQLite is sufficient.

- Install python libraries for Apache Airflow (suggested Python 3.7)

```shell
cd resources/airflow
pip install -r requirements.txt -c constraints.txt
```
- Set the `PROJECT_HOME` env variable with the path of you cloned repository, for example:
```
export PROJECT_HOME=/home/user/Desktop/practica_big_data_2019
```
- Configure airflow environment

```shell
export AIRFLOW_HOME=~/airflow
mkdir $AIRFLOW_HOME/dags
mkdir $AIRFLOW_HOME/logs
mkdir $AIRFLOW_HOME/plugins

airflow users create \
    --username admin \
    --firstname Jack \
    --lastname  Sparrow\
    --role Admin \
    --email example@mail.org
```
- Start airflow scheduler and webserver

```shell
airflow db init
airflow webserver --port 8082
airflow sheduler
```
Vistit http://localhost:8080/home for the web version of Apache Airflow.

- The DAG is defined in `resources/airflow/setup.py`.
- **TODO**: add the DAG and execute it to train the model (see the official documentation of Apache Airflow to learn how to exectue and add a DAG with the airflow command).

```shell

sudo cp /home/jchavezz/Desktop/practica_big_data_2019/resources/airflow/setup.py /home/jchavezz/airflow/dags/ 

```

- **TODO**: explain the architecture of apache airflow (see the official documentation of Apache Airflow).
- **TODO**: analyzing the setup.py: what happens if the task fails?, what is the peridocity of the task?
```shell

* DEFAULT ARGS => Son los argumentos por default, los cuales se pasan al DAG y los comparte a traves de todas las TASK. StartDate indica a partir de cu??ndo el DAG es v??lido, Retries cantidad de veces que se intentar?? realizar el proceso, en esta ser??n 3, v se espera 5 minutos entre cada intento.

* Training_dag => En default_args se define el DAG con los argumentos ya configurados. Schedule_interval indica que no se inicia de manera peri??dica el TASK.

* Pyspark_bash_command // Pyspark_date_bash_command => son comandos a ejecutar

* extract_features_operator => Se reune informaci??n del entrenamiento para clasificarla.

* train_classifier_model_operator => Se entrena el modelo usando el comando pyspark_bash_comand

```
![Apache Airflow DAG success](images/airflow.jpeg)

[<img src="images/AIRFLOW.jpeg">]

## Docker

- Primero se crea red desde el root:
```
docker network create proyecto_fbid
```
Luego se ejecutan los contenedores necesarios:

```
docker run -d --network proyecto_fbid --network-alias flask -p 5000:5000 --name flask john/flask:flask
docker run -d --network proyecto_fbid --network-alias spark --name spark john/spark:spark
docker run -d --network proyecto_fbid --network-alias mongo --name mongo mongo:latest
docker run -d --network proyecto_fbid--network-alias kafka --name kafka john/kafka:kafka
```
Dentro del ubuntu ingresar a:
```
http://localhost:5000/flights/delays/predict_kafka

```

## Docker - Compose

Antes del docker compose ejecutar para parar y eliminar los anteriores contenedores:

```
docker stop $(docker ps -q)  
docker rm $(docker ps -a -q) 

```

- Se ejecuta el archivo YML para poder generar los contenedores:

```
docker-compose up -d
```
Dentro del ubuntu ingresar a:
```
http://localhost:5000/flights/delays/predict_kafka

```
