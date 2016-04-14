package giraph.wrapper;

import giraph.wrapper.util.Timer;

import org.apache.giraph.GiraphRunner;

import argList.ArgList;
import argList.types.array.StringArrayArg;
import argList.types.atomic.IntArg;
import argList.types.atomic.StringArg;

public class GiraphWrapper {

	public String datasetDir;
	public String datasetSuffix;
	public int snapshotFrom;
	public int snapshotTo;
	public String outputDir;
	public String[] args;

	public static final String inputKey = "INPUT_FILE";
	public static final String outputKey = "OUTPUT_DIR";

	public GiraphWrapper(String datasetDir, String datasetSuffix,
			Integer snapshotFrom, Integer snapshotTo, String outputDir,
			String[] args) {
		this.datasetDir = datasetDir;
		this.datasetSuffix = datasetSuffix;
		this.snapshotFrom = snapshotFrom;
		this.snapshotTo = snapshotTo;
		this.outputDir = outputDir;
		this.args = args;
	}

	public static void main(String[] args) throws Exception {
		ArgList<GiraphWrapper> argList = new ArgList<GiraphWrapper>(
				GiraphWrapper.class, new StringArg("datasetDir",
						"path to the dataset directory (on HDFS)"),
				new StringArg("datasetSuffix",
						"suffix of dataset snapshots (e.g., giraphEdgeList"),
				new IntArg("snapshotFrom",
						"index of the first snapshot to analyze"), new IntArg(
						"snapshotTo", "index of the last snapshot to analyze"),
				new StringArg("outputDir",
						"path to the output directory (on HDFS)"),
				new StringArrayArg("args", "args for giraph - "
						+ "',' will be replaced by ' ' - " + outputKey
						+ " and " + inputKey
						+ " will replaces with the corresponding dirs", ","));

		if (args.length == 1) {
			args = new String[] {
					"/Users/benni/TUD/Projects/DNA/DNA.parallel/giraph/_etc/",
					"EDGE_LIST",
					"0",
					"0",
					"output/",
					"ml.grafos.okapi.graphs.ClusteringCoefficient$SendFriendsList,-mc,ml.grafos.okapi.graphs.ClusteringCoefficient$MasterCompute,-eif,ml.grafos.okapi.io.formats.LongNullTextEdgeInputFormat,-eip,INPUT_DIR,-vof,org.apache.giraph.io.formats.IdWithValueTextOutputFormat,-op,OUTPUT_DIR,-w,2,-ca,giraph.oneToAllMsgSending=true" };
		}

		GiraphWrapper gw = argList.getInstance(args);
		gw.execute();
	}

	public void execute() throws Exception {
		Timer total = new Timer("total");
		Timer[] snapshots = new Timer[this.snapshotTo - this.snapshotFrom + 1];

		for (int index = this.snapshotFrom; index <= this.snapshotTo; index++) {
			snapshots[index - this.snapshotFrom] = new Timer("s" + index);
			this.execute(index);
			snapshots[index - this.snapshotFrom].end();
		}

		total.end();

		this.printTimers(total, snapshots);
	}

	protected void execute(int index) throws Exception {
		log("starting execution of snapshot " + index);

		String[] args = new String[this.args.length];
		String input = this.datasetDir + index + this.datasetSuffix;
		String output = this.outputDir + index + "/";
		for (int i = 0; i < args.length; i++) {
			args[i] = this.args[i].replace(inputKey, input).replace(outputKey,
					output);
		}

		GiraphRunner gr = new GiraphRunner();
		gr.run(args);

		log("ended execution of snapshot " + index);
	}

	protected static void log(String msg) {
		System.out.println("log: " + msg);
	}

	protected void printTimers(Timer total, Timer[] snapshots) {
		for (int i = 0; i < snapshots.length; i++) {
			System.out.println("snapshot-" + (i + this.snapshotFrom) + ": "
					+ snapshots[i].getDurationNano());
		}
		System.out.println("total: " + total.getDurationNano());
	}

}
