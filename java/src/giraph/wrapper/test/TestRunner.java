package giraph.wrapper.test;

import org.apache.giraph.examples.ConnectedComponentsComputation;

public class TestRunner {

	public static void main(String[] args) throws Exception {
		// GiraphRunner.main(new String[]{"-h"});
		String[] a = new String[] { "a", "aaa" };
		String[] b = a.clone();
		b[0] = b[0].replace("a", "b");

		for (int i = 0; i < a.length; i++) {
			System.out.println(a[i] + " vs " + b[i]);
		}

		// Jaccard\$SendFriendsList
		// SendFriendsList c = null;
		ConnectedComponentsComputation v = null;
		ml.grafos.okapi.graphs.MultipleSourceShortestPaths m1 = null;
	}

}
