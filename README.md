# GiraphWrapper



## Resources

- Giraph Quick Start Guide <http://giraph.apache.org/quick_start.html>
- GiraphRunner class <https://giraph.apache.org/xref/org/apache/giraph/GiraphRunner.html>
- GiraphRunner class <https://giraph.apache.org/apidocs/org/apache/giraph/GiraphRunner.html>
- Example to run Giraph (IO!): <https://marsty5.com/2013/04/29/run-example-in-giraph-shortest-paths/>
- Example for GiraphRunner (Args!): <https://blog.cloudera.com/blog/2014/02/how-to-write-and-run-giraph-jobs-on-hadoop/>






## directory structure of `results/`

The measured runtimes for analyzing a given setup with Giraph are written to the following directory structure:

	results/
 		<dataset>/
 			<batches>/
 				<partitioning>/
	 				<metric>/
						<workers>/
							<run>.dat
							aggr

The results from multiple runs (= repetitions) of the same setup are aggregated in `aggr`.




## metrics from Giraph

Here, metrics used from giraph examples are listed.
Each metric is specified as:

- **KEY**: name/link

### sources
- <https://www.quora.com/What-are-the-algorithms-built-of-top-of-Giraph-by-far>
- <http://giraph.apache.org>
- <https://github.com/apache/giraph/tree/release-1.0/giraph-examples/src/main/java/org/apache/giraph/examples>

### we use:
- **GIRAPH\_WEAK\_CONNECTIVITY**
	- [ConnectedComponentsComputation.java](https://apache.googlesource.com/giraph/+/3d4f31343c3686435696e75ce88a75c9bffb024e/giraph-examples/src/main/java/org/apache/giraph/examples/ConnectedComponentsComputation.java)
	- directed / undirected unweighted => EdgeList

### tested but not working

- **GIRAPH\_TRIANGLE\_CLOSING** (not terminating)
	- [SimpleTriangleClosingVertex.java](https://github.com/apache/giraph/blob/release-1.0/giraph-examples/src/main/java/org/apache/giraph/examples/SimpleTriangleClosingVertex.java)
	- ? => ?
- **GIRAPH\_IN\_DEGREE** (incorrect input format?!?)
	- [SimpleInDegreeCountVertex.java](https://github.com/apache/giraph/blob/release-1.0/giraph-examples/src/main/java/org/apache/giraph/examples/SimpleInDegreeCountVertex.java)
	- ? => ?
- **GIRAPH\_OUT\_DEGREE** (incorrect input format?!?)
	- [SimpleOutDegreeCountVertex.java](https://github.com/apache/giraph/blob/release-1.0/giraph-examples/src/main/java/org/apache/giraph/examples/SimpleOutDegreeCountVertex.java)
	- ? => ?
- **GIRAPH\_APSP\_SINGLE** (incorrect input format?!?)
	- [SimpleShortestPathsVertex.java](https://github.com/apache/giraph/blob/release-1.0/giraph-examples/src/main/java/org/apache/giraph/examples/SimpleShortestPathsVertex.java)
	- ? => ?


### others:
- random walk
- page rank


## metrics from Okapi

Here, metrics used from ocapi are listed.
*W* identifies algorithms working for weighted graphs, *D* are directed graphs, and *U* are undirected graphs.
*U & D* means that the algorithm can be applied to directed or undirected graphs, if only one is used the other is assumed to not be supported.
*W* menas that weighted graphs are supported but no statement about directed or undirected is mde.

Each algorithm is specified as:

- **KEY**: [name/link]() (*graph type*) (optional description)

### sources
- <http://grafos.ml/okapi.html#analytics>
- <https://github.com/grafos-ml/okapi/tree/master/src/main/java/ml/grafos/okapi/graphs>

### we use:

- **OKAPI\_CLUSTERING\_COEFFICIENT**
	- [Readme](http://grafos.ml/okapi.html#analytics-clcoef)
	- [ClusteringCoefficient.java](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/ClusteringCoefficient.java)
	- directed / undirected, unweighted => EdgeList
- **OKAPI\_TRIANGLES\_COUNT**
	- [Readme](http://grafos.ml/okapi.html#analytics-tr)
	- [Triangles.java](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/Triangles.java)
	- undirected, unweighted => EdgeList
- **OKAPI\_TRIANGLES\_LIST**
	- [Readme](http://grafos.ml/okapi.html#analytics-tr)
	- [Triangle.java](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/Triangles.java)
	- undirected, unweighted => EdgeList
- **OKAPI\_JACCARD\_EXACT**
	- [Readme](http://grafos.ml/okapi.html#analytics-jacc)
	- [Jaccard.java](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/similarity/Jaccard.java)
	- directed / undirected, unweighted => EdgeList
- **OKAPI\_JACCARD\_APPROX**
	- [Readme](http://grafos.ml/okapi.html#analytics-jacc)
	- [Jaccard.java](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/similarity/Jaccard.java)
	- directed / undirected, unweighted => EdgeList
- **OKAPI\_MSSP\_LIST\_${list of vertex indexes}**
	- [Readme](http://grafos.ml/okapi.html#analytics-mssp)
	- [MultipleSourceShortestPaths.java](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/MultipleSourceShortestPaths.java)
	- directed / undirected, weighted => WeightedEdgeList
	- indexes must be separated by `:`, e.g., `0:35:2:5`

### tested but not working

- **OKAPI\_MSSP\_FRACTION\_${fraction of vertices to use as source}** (always fails)
	- [Readme](http://grafos.ml/okapi.html#analytics-mssp)
	- [MultipleSourceShortestPaths.java](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/MultipleSourceShortestPaths.java)
	- directed / undirected, weighted => WeightedEdgeList
	- fraction is specified as a decimal number, e.g., `0.12` for 12%

### others:

- [K-core](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/KCore.java)
- [Semi-clustering](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/SemiClustering.java) (W)
- [Semi-metric](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/ScalableSemimetric.java)
- [Semi-metric triangles](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/SemimetricTriangles.java)
- [Page rang](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/SimplePageRank.java)
- [Sybil rank](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/SybilRank.java) (W)
- [Adamic-Adar similarity](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/similarity/AdamicAdar.java) (U)
- [Maximum B-matching](https://github.com/grafos-ml/okapi/blob/master/src/main/java/ml/grafos/okapi/graphs/maxbmatching/MaxBMatching.java)









## Arguments for the use of GiraphRunner

- <http://giraph.apache.org/options.html>
- <http://giraph.apache.org/quick_start.html>

### complete help output (`GiraphRunner -h`)


	usage: org.apache.giraph.utils.ConfigurationUtils [-aw <arg>] [-c <arg>]
	       [-ca <arg>] [-cf <arg>] [-eif <arg>] [-eip <arg>] [-eof <arg>]
	       [-esd <arg>] [-h] [-jyc <arg>] [-la] [-mc <arg>] [-op <arg>] [-pc
	       <arg>] [-q] [-th <arg>] [-ve <arg>] [-vif <arg>] [-vip <arg>] [-vof
	       <arg>] [-vsd <arg>] [-vvf <arg>] [-w <arg>] [-wc <arg>] [-yh <arg>]
	       [-yj <arg>]
	 -aw,--aggregatorWriter <arg>           AggregatorWriter class
	 -c,--combiner <arg>                    MessageCombiner class
	 -ca,--customArguments <arg>            provide custom arguments for the
	                                        job configuration in the form: -ca
	                                        <param1>=<value1>,<param2>=<value2
	                                        > -ca <param3>=<value3> etc. It
	                                        can appear multiple times, and the
	                                        last one has effect for the same
	                                        param.
	 -cf,--cacheFile <arg>                  Files for distributed cache
	 -eif,--edgeInputFormat <arg>           Edge input format
	 -eip,--edgeInputPath <arg>             Edge input path
	 -eof,--edgeOutputFormat <arg>          Edge output format
	 -esd,--edgeSubDir <arg>                subdirectory to be used for the
	                                        edge output
	 -h,--help                              Help
	 -jyc,--jythonClass <arg>               Jython class name, used if
	                                        computation passed in is a python
	                                        script
	 -la,--listAlgorithms                   List supported algorithms
	 -mc,--masterCompute <arg>              MasterCompute class
	 -op,--outputPath <arg>                 Output path
	 -pc,--partitionClass <arg>             Partition class
	 -q,--quiet                             Quiet output
	 -th,--typesHolder <arg>                Class that holds types. Needed
	                                        only if Computation is not set
	 -ve,--outEdges <arg>                   Vertex edges class
	 -vif,--vertexInputFormat <arg>         Vertex input format
	 -vip,--vertexInputPath <arg>           Vertex input path
	 -vof,--vertexOutputFormat <arg>        Vertex output format
	 -vsd,--vertexSubDir <arg>              subdirectory to be used for the
	                                        vertex output
	 -vvf,--vertexValueFactoryClass <arg>   Vertex value factory class
	 -w,--workers <arg>                     Number of workers
	 -wc,--workerContext <arg>              WorkerContext class
	 -yh,--yarnheap <arg>                   Heap size, in MB, for each Giraph
	                                        task (YARN only.) Defaults to
	                                        giraph.yarn.task.heap.mb => 1024
	                                        (integer)
	                                        MB.
	 -yj,--yarnjars <arg>                   comma-separated list of JAR
	                                        filenames to distribute to Giraph
	                                        tasks and ApplicationMaster. YARN
	                                        only. Search order: CLASSPATH,
	                                        HADOOP_HOME, user current dir.


### components

#### edges

	 -eif,--edgeInputFormat <arg>           Edge input format
	 -eip,--edgeInputPath <arg>             Edge input path
	 -eof,--edgeOutputFormat <arg>          Edge output format
	 -esd,--edgeSubDir <arg>                subdirectory to be used for the
	                                        edge output

#### vertices

	 -ve,--outEdges <arg>                   Vertex edges class
	 -vif,--vertexInputFormat <arg>         Vertex input format
	 -vip,--vertexInputPath <arg>           Vertex input path
	 -vof,--vertexOutputFormat <arg>        Vertex output format
	 -vsd,--vertexSubDir <arg>              subdirectory to be used for the
	                                        vertex output
	 -vvf,--vertexValueFactoryClass <arg>   Vertex value factory class


#### log

	 -h,--help                              Help
	 -q,--quiet                             Quiet output

#### results

	 -op,--outputPath <arg>                 Output path

#### computation

	 -mc,--masterCompute <arg>              MasterCompute class
	 -pc,--partitionClass <arg>             Partition class


#### workers

	 -w,--workers <arg>                     Number of workers
	 -wc,--workerContext <arg>              WorkerContext class


#### misc

	 -jyc,--jythonClass <arg>               Jython class name, used if
	                                        computation passed in is a python
	                                        script
	 -yj,--yarnjars <arg>                   comma-separated list of JAR
	                                        filenames to distribute to Giraph
	                                        tasks and ApplicationMaster. YARN
	                                        only. Search order: CLASSPATH,
	                                        HADOOP_HOME, user current dir.
	 -yh,--yarnheap <arg>                   Heap size, in MB, for each Giraph
	                                        task (YARN only.) Defaults to
	                                        giraph.yarn.task.heap.mb => 1024
	                                        (integer)
	                                        MB.
	 -ca,--customArguments <arg>            provide custom arguments for the
	                                        job configuration in the form: -ca
	                                        <param1>=<value1>,<param2>=<value2
	                                        > -ca <param3>=<value3> etc. It
	                                        can appear multiple times, and the
	                                        last one has effect for the same
	                                        param.
	 -cf,--cacheFile <arg>                  Files for distributed cache
	 -la,--listAlgorithms                   List supported algorithms
	 -th,--typesHolder <arg>                Class that holds types. Needed
	                                        only if Computation is not set
	 -aw,--aggregatorWriter <arg>           AggregatorWriter class
	 -c,--combiner <arg>                    MessageCombiner class
