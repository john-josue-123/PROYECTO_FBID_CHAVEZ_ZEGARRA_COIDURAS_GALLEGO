# This is the text that I edit to compile the project, and this need to place in root user
#~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n 2> /dev/null || true

export SPARK_HOME=/opt/spark
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export PYSPARK_PYTHON=/usr/bin/python3
export PATH="$PATH:/root/.local/share:$SPARK_HOME/bin:$SPARK_HOME/sbin"
export PROJECT_HOME=/home/jchavezz/Desktop/practica_big_data_2019
export AIRFLOW_HOME=/home/jchavezz/Desktop/practica_big_data_2019/resources/airflow
