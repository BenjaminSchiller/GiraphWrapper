# Hadoop

![Hadoop](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Hadoop_logo.svg/664px-Hadoop_logo.svg.png)

## installing hadoop

For information how to install hadoop from scratch, please refer to the [Giraph Quick Start Guide](http://giraph.apache.org/quick_start.html).

In the guide, `HADOOP_HOME` is used to refer to the install location.
This is deprecated and should be replaces with `HADOOP_PREFIX` in all config files.


## configuration files (changes to default) (!!!)

In the default configuration, only 4 mappers are configured in `mapred-site.xml`.
Use the following configuration to allow up to 60.

	<property>
	<name>mapred.job.tracker</name> 
	<value>hdnode01:54311</value>
	</property>
	
	<property>
	<name>mapred.tasktracker.map.tasks.maximum</name>
	<value>60</value>
	</property>
	
	<property>
	<name>mapred.map.tasks</name>
	<value>60</value>
	</property>

By default, the HDFS files are stored on the main system partition (/app/hadoop/tmp).
In order change this, `core-site.xml` must be adapted.
In the following example, the data is stored on an *ssd* drive instead of the system *hdd*.

	<property>
	<name>hadoop.tmp.dir</name>
	<value>/media/ssd/hduser/hadoop/tmp</value>
	</property>
	
	<property> 
	<name>fs.default.name</name> 
	<value>hdfs://hdnode01:54310</value> 
	</property>


## updating hadoop

To update to a newer version of hadoop (e.g., 1.2.1) after performing the complete install process once, execute the following commands:
	
	cd /usr/local
	sudo wget http://archive.apache.org/dist/hadoop/core/hadoop-1.2.1/hadoop-1.2.1.tar.gz
	sudo tar xzf hadoop-1.2.1.tar.gz
	sudo chown -R hduser:hadoop hadoop-1.2.1
	sudo ln -s hadoop-1.2.1 hadoop

Afterwards, the following config files need to be adapted as described in the [Giraph Quick Start Guide](http://giraph.apache.org/quick_start.html).
Note the (potentially required) changes to the default configuration mentioned above.

- $HADOOP_PREFIX/conf/hadoop-env.sh (*maybe you need to change the java home value*)
- $HADOOP_PREFIX/conf/core-site.xml
- $HADOOP_PREFIX/conf/mapred-site.xml
- $HADOOP_PREFIX/conf/hdfs-site.xml

Then, replace `localhost` with `hdnode01` in the following two config files:

- $HADOOP_PREFIX/conf/masters
- $HADOOP_PREFIX/conf/slaves

Finally, reformat the HDFS filesystem:

	sudo rm -r /app/hadoop/tmp/dfs
	sudo rm -r /app/hadoop/tmp/mapred
	su hduser
	$HADOOP_PREFIX/bin/hadoop namenode -format

## maintenance

### starting

To start all required hadoop services, run the following command (as hduser):

	su hduser
	$HADOOP_PREFIX/bin/start-dfs.sh; $HADOOP_PREFIX/bin/start-mapred.sh


### status

To check the status of running hadoop processes, use the following command:

	ps aux | grep java | grep -v grep | awk '{print $2, $12}'

This should results in the following five (!) lines (ignore the process numbers):

	5523 -Dproc_namenode
	5765 -Dproc_datanode
	6012 -Dproc_secondarynamenode
	6208 -Dproc_jobtracker
	6416 -Dproc_tasktracker


### stoping

To stop all hadoop services, run the following command (as hduser):

	su hduser
	$HADOOP_PREFIX/bin/stop-mapred.sh; $HADOOP_PREFIX/bin/stop-dfs.sh


### script `hd.sh`

In the [Giraph evaluation / execution directory](../giraph) you can find a script ([hd.sh](../giraph/hd.sh)) for executiing these operations:

	hd.sh start
	hd.sh stop
	hd.sh status
	hd.sh version