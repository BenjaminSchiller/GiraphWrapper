package giraph.wrapper;

public class Components {
	public static enum DatasetFormat {
		ADJACENCY_LIST, EDGE_LIST
	}

	public static enum Metric {
		OKAPI_CLUSTERING_COEFFICIENT, OKAPI_JACCARD_EXACT, OKAPI_JACCARD_APPROX, OKAPI_TRIANGLE_COUNT, OKAPI_TRIANGLE_FIND
	}

	public static enum Partitioning {
		HASH
	}
}
