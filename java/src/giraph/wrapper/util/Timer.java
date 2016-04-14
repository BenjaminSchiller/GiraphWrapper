package giraph.wrapper.util;

public class Timer {
	private String name;
	private long start;
	private long duration;

	public Timer(String name) {
		this.name = name;
		this.start = System.nanoTime();
		this.duration = 0;
	}

	public Timer() {
		this(null);
	}

	public void end() {
		this.duration += System.nanoTime() - this.start;
	}

	public long getDurationNano() {
		return this.duration;
	}

	public long getDurationMili() {
		return this.duration;
	}

	public long getDurationSec() {
		return this.duration;
	}

	public void reset() {
		this.duration = 0;
		this.start = System.nanoTime();
	}

	public void restart() {
		this.start = System.nanoTime();
	}

	public String toString() {
		return this.getDurationNano() + " nsec / " + this.getDurationMili()
				+ " msec / " + this.getDurationSec() + " sec";
	}

	public void print() {
		System.out.println(this.name + ": " + this.toString());
	}
}
