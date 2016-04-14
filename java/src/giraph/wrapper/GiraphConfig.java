package giraph.wrapper;

import giraph.wrapper.Components.Metric;
import giraph.wrapper.Components.Partitioning;

import java.util.ArrayList;

public class GiraphConfig {
	public String m = null;
	public String mc = null;
	public ArrayList<String> cas = new ArrayList<String>();

	public String eip = null;
	public String op = null;

	public String pc = null;

	public String w = null;

	public String eif = "ml.grafos.okapi.io.formats.LongNullTextEdgeInputFormat";
	public String vof = "org.apache.giraph.io.formats.IdWithValueTextOutputFormat";

	public GiraphConfig(Metric metric, String input, String output,
			Partitioning partitioning, int workers) {
		switch (metric) {
		case OKAPI_CLUSTERING_COEFFICIENT:
			this.m = "ml.grafos.okapi.graphs.ClusteringCoefficient$SendFriendsList";
			this.mc = "ml.grafos.okapi.graphs.ClusteringCoefficient$MasterCompute";
			this.eif = "ml.grafos.okapi.io.formats.LongNullTextEdgeInputFormat";
			this.vof = "org.apache.giraph.io.formats.IdWithValueTextOutputFormat";
			this.cas.add("giraph.oneToAllMsgSending=true");
			break;
		case OKAPI_JACCARD_EXACT:
			this.m = "ml.grafos.okapi.graphs.Jaccard$SendFriendsList";
			this.mc = "ml.grafos.okapi.graphs.Jaccard$MasterCompute";
			this.eif = "ml.grafos.okapi.io.formats.LongDoubleZerosTextEdgeInputFormat";
			
			this.cas.add("jaccard.approximation.enabled=false");
			break;
		case OKAPI_JACCARD_APPROX:
			break;
		case OKAPI_TRIANGLE_COUNT:
			this.m = "ml.grafos.okapi.graphs.Triangles$Initialize";
			this.mc = "ml.grafos.okapi.graphs.Triangles$TriangleCount";
			this.cas.add("giraph.outEdgesClass=org.apache.giraph.edge.HashMapEdges");
			break;
		case OKAPI_TRIANGLE_FIND:
			this.m = "ml.grafos.okapi.graphs.Triangles$Initialize";
			this.mc = "ml.grafos.okapi.graphs.Triangles$TriangleFind";
			this.cas.add("giraph.outEdgesClass=org.apache.giraph.edge.HashMapEdges");
			break;
		default:
			throw new IllegalArgumentException("unknown metric: " + metric);
		}

		switch (partitioning) {
		case HASH:
			this.pc = "org.apache.giraph.partition.HashPartitionerFactory";
			break;
		default:
			throw new IllegalArgumentException("unknown partitioning: "
					+ partitioning);
		}

		this.eip = input;
		this.op = output;
		this.w = "" + workers;
	}

	public String[] getArgs() {
		String args = m;
		args += " -mc " + mc;
		args += " -eip " + eip;
		args += " -op " + op;

		args += " -w " + w;

		args += " -eif " + eif;
		args += " -vof " + vof;

		for (String ca : cas)
			args += " -ca " + ca;

		// args += " -Dgiraph.graphPartitionerFactoryClass=" + pc;

		return args.split(" ");
	}
}
