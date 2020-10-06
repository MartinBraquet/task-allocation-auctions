import java.io.*;
import java.net.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.ArrayList;
import java.util.Date;

// USARSim State Message Object for Ground Vehicles
class usarStateGroundVehicle
{
	public double TimeStamp;
	public double FrontSteer;
	public double RearSteer;
	public boolean LightToggle;
	public int LightIntensity;
	public int BatteryLife;

	public usarStateGroundVehicle(double tmStamp, double frSteer, double rrSteer, boolean lightTog, int lightInt, int battLife)
	{
		this.TimeStamp = tmStamp;
		this.FrontSteer = frSteer;
		this.RearSteer = rrSteer;
		this.LightToggle = lightTog;
		this.LightIntensity = lightInt;
		this.BatteryLife = battLife;
	}

}

//USARSim Mission State Package Object
class usarMissionState
{
	public String Name;
	public double TimeStamp;
	public int[] Link;
	public double[] Value;
	public double[] Torque;

	public usarMissionState(String msName, double ts, int[] lnk, double[] val, double[] trq)
	{
		this.Name = msName;
		this.TimeStamp = ts;
		this.Link = lnk;
		this.Value = val;
		this.Torque = trq;
	}
}

// Sonar sensor class
class usarSensorSonar
{
	public String[] Name;
	public double TimeStamp;
	public double[] Range;

	public usarSensorSonar(String[] sonName, double sonTimeStamp, double[] sonRange)
	{
		this.Name = sonName;
		this.Range = sonRange;
		this.TimeStamp=sonTimeStamp;
	}
}

// Laser range finder sensor class
class usarSensorLaser
{
	public String Name;
	public double TimeStamp;
	public double Resolution;
	public double FieldOfView;
	public double[] Scans;

	public usarSensorLaser(String lasName, double lasTimeStamp, double lasRes, double lasFOV, double[] lasScans)
	{
		this.Name = lasName;
		this.TimeStamp = lasTimeStamp;
		this.Resolution = lasRes;
		this.FieldOfView = lasFOV;
		this.Scans = lasScans;
	}
}

// Odometry sensor class
class usarSensorOdometry
{
	public String Name;
	public double TimeStamp;
	public double[] Pose = new double[3];

	public usarSensorOdometry(String odName, double odTimeStamp, double[] odpose)
	{
		this.Name = odName;
		this.TimeStamp = odTimeStamp;
		this.Pose = odpose;
	}
}

// GPS sensor class
class usarSensorGPS
{
	public String Name;
	public double TimeStamp;
	public double Latitude;
	public double Longitude;
	public int GotFix;
	public int NumSatellites;

	public usarSensorGPS(String gpsName, double gpsTimeStamp, double lat, double lng, int fix, int numSat)
	{
		this.Name = gpsName;
		this.TimeStamp = gpsTimeStamp;
		this.Latitude = lat;
		this.Longitude = lng;
		this.GotFix = fix;
		this.NumSatellites = numSat;
	}
}

// INS sensor class
class usarSensorINS
{
	public String Name;
	public double TimeStamp;
	public double[] Position = new double[3];
	public double[] Orientation = new double[3];

	public usarSensorINS(String insName, double insTimeStamp, double[] pos, double[] orient)
	{
		this.Name = insName;
		this.TimeStamp = insTimeStamp;
		this.Position = pos;
		this.Orientation = orient;
	}
}

// Encoder sensor class
class usarSensorEncoder
{
	public String[] Name;
	public double TimeStamp;
	public int[] Ticks;

	public usarSensorEncoder(String[] encoderNames, double encTimeStamp, int[] encoderTicks)
	{
		this.Name = encoderNames;
		this.TimeStamp = encTimeStamp;
		this.Ticks = encoderTicks;
	}
}

// Touch sensor class
class usarSensorTouch
{
	public String[] Name;
	public double TimeStamp;
	public boolean[] State;

	public usarSensorTouch(String[] touchNames, double touTimeStamp, boolean[] touchSta)
	{
		this.Name = touchNames;
		this.TimeStamp = touTimeStamp;
		this.State = touchSta;
	}
}

// Ground vehicle geometry class
class usarGroundVehicleGeometry
{
	public String Name;
	public float[] Dimensions;
	public float[] CenterOfGravity;
	public float WheelRadius;
	public float WheelSeparation;
	public float WheelBase;

	public usarGroundVehicleGeometry(String name, float[] dim, float[] cog, float radius, float sep, float base)
	{
		this.Name = name;
		this.Dimensions = dim;
		this.CenterOfGravity = cog;
		this.WheelRadius = radius;
		this.WheelSeparation = sep;
		this.WheelBase = base;
	}
}

// RFID Code from
class usarSensorRFID
{
	public String Name;
	public double TimeStamp;
	public int[] IDs;
	public String[] data;
	
	public usarSensorRFID(String name, double rfTimeStamp, int[] IDsin, String[] datain)
	{
		Name = name;
		TimeStamp = rfTimeStamp;
		IDs = IDsin;
		data = datain;
	}
}

class usarGroundTruth
{
	public double[] pos,orient;
	public double TimeStamp;
	
	public usarGroundTruth(double[] posIn, double gtTimeStamp, double[] orientIn)
	{
		pos = posIn;
		TimeStamp = gtTimeStamp;
		orient = orientIn;
	}
}

class USARSim
{
	// list of state and mission state variables
	public usarStateGroundVehicle STAGndVehicle;
	public ArrayList<usarMissionState> MISSTApackage;

	// list of sensor variables
	public usarSensorOdometry SENOdometry;
	public usarSensorGPS SENGPS;
	public usarSensorINS SENINS;
	public usarSensorEncoder SENEncoders;
	public usarSensorSonar SENSonars;
	public usarSensorLaser SENLasers;
	public usarSensorTouch SENTouch;
	public usarSensorRFID SENRFID;
	public usarGroundTruth SENTruth;

	// list of geometry variables
	public usarGroundVehicleGeometry GEOGndVehicle;

	// list of variables used for reading/sending messages from/to Unreal
	private Socket sock;
	private OutputStreamWriter writer;
	private DataOutputStream byteWriter;
	private DataInputStream byteReader;
	private StringBuffer inMessage;
	private String ip;
	private int bufferChunk;
	
	// FRAPS variables
	private int imgResol = 1;
	private int imgQuality = 1;

	// debug variable
	private String dbgMsg;

	// list of variables for thread handling incoming messages from Unreal
	private boolean running;
	private Thread msgWorker;
	
	/*// queue of times of the last N number of messages, for benchmarking purposes
	private Date[] timeLog;
	private int currentTime;
	public final int maxTimes = 20;*/	
	
	// this starts connection to USARSim running on local computer
	public USARSim() throws IOException
	{
		this.ip = InetAddress.getLocalHost().getHostAddress();
		this.initialize();
	}

	private void initialize() throws IOException
	{
		/*// initialize the time log
		timeLog = new Date[maxTimes];
		currentTime = 0;*/
		
		// state variables
		this.STAGndVehicle = new usarStateGroundVehicle(0.0, 0.0, 0.0, false, 0, 0);
		this.MISSTApackage = new ArrayList<usarMissionState>();
		/*	new usarMissionState("ms1", 0.0, new int[] { 0, 0 }, new double[] { 0.0, 0.0 },
						new double[] { 0.0, 0.0 });*/

		// sensor variables
		this.SENSonars = new usarSensorSonar(new String[] { "S1", "S2" },0, new double[] { 0.0, 0.0 });
		this.SENLasers = new usarSensorLaser("Laser", 0, 0.0, 0.0, new double[] { 0.0, 0.0 });
		this.SENOdometry = new usarSensorOdometry("odometer1", 0, new double[] { 0.0, 0.0, 0.0 });
		this.SENGPS = new usarSensorGPS("gps1", 0, 0.0, 0.0, 0, 0);
		this.SENINS = new usarSensorINS("ins1", 0, new double[] { 0.0, 0.0, 0.0 },
						new double[] { 0.0, 0.0, 0.0 });
		this.SENEncoders = new usarSensorEncoder(new String[] { "RightWheel", "LeftWheel" }, 0,
						new int[] { 0, 0 });
		this.SENTouch = new usarSensorTouch(new String[] { "T1", "T2" }, 0, new boolean[] { false, false });
		this.SENRFID = new usarSensorRFID("", 0, new int[] {},new String[] {});
		this.SENTruth = new usarGroundTruth(new double[] {}, 0,new double[] {});
		
		// geometry variables
		this.GEOGndVehicle = new usarGroundVehicleGeometry("vehicleType", new float[] { 0, 0, 0 },
						new float[] { 0, 0, 0 }, 0, 0, 0);

		// msg passing variables
		this.sock = new Socket(this.ip, 3000);
		this.sock.setTcpNoDelay(true);
		this.sock.setSoTimeout(5000);
		this.writer = new OutputStreamWriter(this.sock.getOutputStream(), "US-ASCII");
		this.byteWriter = new DataOutputStream(this.sock.getOutputStream());
		this.byteReader = new DataInputStream(this.sock.getInputStream());
		this.inMessage = new StringBuffer();
		this.bufferChunk = 512; // Get 512 characters at a time.
	}

	// This shuts down the connection to USARSim
	public void shutdown() throws IOException
	{
		this.writer.close();
		this.byteWriter.close();
		this.byteReader.close();
		this.sock.close();
	}

	public void reset() throws IOException
	{
		this.shutdown();
		this.initialize();
	}

	// Message Reading Thread
	public void start()
	{
		if (this.running)
		{
			System.out.println("Parser thread is already running!");
		}
		else
		{
			this.running = true;
			this.msgWorker = new Thread(new ParseWorker());
			this.msgWorker.start();
			//this.worker = new Thread(new ParseWorker());
			//this.worker.start();
		}
	}

	public void stop() throws InterruptedException
	{
		if (this.running)
		{
			this.running = false;
			this.msgWorker.join();
			//this.worker.join();
		}
	}
	
	/*// get the current speed of incoming messages in messages/second
	public double getMesRate(){
		// milliseconds in the last maxTimes number of messages
		//double milli = timeLog[currentTime].getTime() - timeLog[(currentTime + 1) % maxTimes].getTime();
		double milli = (new Date()).getTime() - timeLog[(currentTime + 1) % maxTimes].getTime();
		
		return (maxTimes / milli * 1000);
		
	}*/

	// Outputs latest state message
	public usarStateGroundVehicle getStateGroundVehilce()
	{
		return this.STAGndVehicle;
	}

	// Outputs latest mission state message
	public usarMissionState[] getMissionState()
	{
		//return this.MISSTApackage as an array of usarMissionState classe b/c robots can have more than one
		return this.MISSTApackage.toArray(new usarMissionState[MISSTApackage.size()]);
	}

	// Outputs latest Sonar sensor message
	public usarSensorSonar getSensorSonar()
	{
		return this.SENSonars;
	}

	// Outputs latest Laser sensor message
	public usarSensorLaser getSensorLaser()
	{
		return this.SENLasers;
	}

	// Outputs latest Odometry sensor message
	public usarSensorOdometry getSensorOdometry()
	{
		return this.SENOdometry;
	}

	// Outputs latest GPS sensor message
	public usarSensorGPS getSensorGPS()
	{
		return this.SENGPS;
	}

	// Outputs latest INS sensor message
	public usarSensorINS getSensorINS()
	{
		return this.SENINS;
	}

	// Outputs latest Encoder sensor message
	public usarSensorEncoder getSensorEncoders()
	{
		return this.SENEncoders;
	}

	// Outputs latest Touch sensor message
	public usarSensorTouch getSensorTouch()
	{
		return this.SENTouch;
	}
	
	// Outputs latest RFID message
	public usarSensorRFID getRFID()
	{
		return this.SENRFID;
	}

	// Outputs latest ground vehicle geometry message
	public usarGroundVehicleGeometry getGeometryGroundVehicle()
	{
		return this.GEOGndVehicle;
	}
	
	public usarGroundTruth getSENGroundTruth()
	{
		return this.SENTruth;
	}
	
	// Data Storage variables needed for vision code to store information
	public void setResolution(int newRes)
	{
		imgResol = newRes;
	}
	
	public void setQuality(int newQual)
	{
		imgQuality = newQual;
	}

	public int getResolution()
	{
		return this.imgResol;
	}
	
	public int getQuality()
	{
		return this.imgQuality;
	}
	
	// Used for debugging purposes
	public String showDebugMessage()
	{
		return this.dbgMsg;
	}

	// Function to initialize a robot within the workspace
	public void spawnRobot(String robot_class, String robot_id, double[] pose_xyz, double[] pose_rpy) throws IOException
	{
		String msg = "INIT {ClassName USARBot." + robot_class + "} {Name " + robot_id + "} {Location " + pose_xyz[0] + "," + pose_xyz[1] + "," + pose_xyz[2] + "} {Rotation " + pose_rpy[0] + "," + pose_rpy[1] + "," + pose_rpy[2] + "}";
		writeMsg(msg);

		/* Sending Query Commands. The way this is set up is that the GETCONF will intialize object, so you need to call "GETCONF" first.
		 * This needs some work.  We really need to be looking up the robot type and then determine which of these need to be sent rather
		 * than spamming USARSim with every object supported
		 */
		sendQueryCmd("GETCONF", "Robot");
		sendQueryCmd("GETGEO", "Robot");
		sendQueryCmd("GETCONF", "MisPkg");
		sendQueryCmd("GETGEO", "MisPkg");
		sendQueryCmd("GETCONF", "Effecter");
		sendQueryCmd("GETGEO", "Effecter");
		sendQueryCmd("GETCONF", "RangeScanner");
		sendQueryCmd("GETGEO", "RangeScanner");
		sendQueryCmd("GETCONF", "Sonar");
		sendQueryCmd("GETGEO", "Sonar");
		sendQueryCmd("GETCONF", "INU");
		sendQueryCmd("GETGEO", "INU");
		sendQueryCmd("GETCONF", "INS");
		sendQueryCmd("GETGEO", "INS");
		sendQueryCmd("GETCONF", "Encoder");
		sendQueryCmd("GETGEO", "Encoder");
		sendQueryCmd("GETCONF", "Odometry");
		sendQueryCmd("GETGEO", "Odometry");
		sendQueryCmd("GETCONF", "Touch");
		sendQueryCmd("GETGEO", "Touch");
		sendQueryCmd("GETCONF", "RFID");
		sendQueryCmd("GETGEO", "RFID");
		sendQueryCmd("GETCONF", "VictSensor");
		sendQueryCmd("GETGEO", "VictSensor");
		sendQueryCmd("GETCONF", "Camera");
		sendQueryCmd("GETGEO", "Camera");
		sendQueryCmd("GETCONF", "GroundTruth");
		sendQueryCmd("GETGEO", "GroundTruth");
	}

	// Function that parses all the incoming messages from USARSim
	private class ParseWorker implements Runnable
	{
		// Regular expressions for the messages we know about.
		// Regular expressions for the messages we know about.
		private String freg = "-?\\d+(?:\\.\\d+)?"; // A number; possibly decimal.

		private String wreg = "\\w+"; // A word
		
		// general timestamp pattern
		private Pattern time = Pattern.compile("\\{Time (" + freg + ")\\}");
		
		// Patterns for STA messages
		private Pattern staMain = Pattern.compile("STA");
		private Pattern staType = Pattern.compile("\\{Type (" + wreg + ")\\}");
		private Pattern staTime = Pattern.compile("\\{Time (" + freg + ")\\}");
		private Pattern staFrontSteer = Pattern.compile("\\{FrontSteer (" + freg + ")\\}");
		private Pattern staRearSteer = Pattern.compile("\\{RearSteer (" + freg + ")\\}");
		private Pattern staLightToggle = Pattern.compile("\\{LightToggle (" + wreg + ")\\}");
		private Pattern staLightIntensity = Pattern.compile("\\{LightIntensity (" + freg + ")\\}");
		private Pattern staBattery = Pattern.compile("\\{Battery (" + freg + ")\\}");

		// Patterns for MISSTA messages
		private Pattern misstaMain = Pattern.compile("MISSTA");
		private Pattern misstaTime = Pattern.compile("\\{Time (" + freg + ")\\}");
		private Pattern misstaName = Pattern.compile("\\{Name (" + wreg + ")\\}");
		private Pattern misstaLinkInfo = Pattern.compile("\\{Link (" + freg + ")\\} \\{Value (" + freg +
									")\\} \\{Torque (" + freg + ")\\}*");

		// Patterns for SEN messages
		private Pattern senMain = Pattern.compile("SEN");
		private Pattern senTime = Pattern.compile("\\{Time (" + freg + ")\\}");
		private Pattern senType = Pattern.compile("\\{Type (" + wreg + ")\\}");
		private Pattern senName = Pattern.compile("\\{Name (" + wreg + ")\\}");
		//RFID Sensor
		private Pattern senRFIDName = Pattern.compile("\\{Name (" + wreg + ")\\}");
		private Pattern senRFID = Pattern.compile("\\{ID (" + freg + ")\\} \\{Mem (" + wreg + ")\\}*");
		// Sonar
		private Pattern senSonars = Pattern.compile("\\{Name (" + wreg + ") Range (" + freg + ")\\}*");
		// Laser Range Finder
		private Pattern senLaserResolution = Pattern.compile("\\{Resolution (" + freg + ")\\}");
		private Pattern senLaserFOV = Pattern.compile("\\{FOV (" + freg + ")\\}");
		private Pattern senLaserScanFirst = Pattern.compile("\\{Range (" + freg + "),");
		private Pattern senLaserScanMiddle = Pattern.compile("(" + freg + ")[,\\}]*");
		// Odometry sensor
		private Pattern senOdometryPose = Pattern.compile("\\{Pose (" + freg + "),\\s*(" + freg +
									"),(" + freg + ")\\}");
		// GPS sensor
		private Pattern senGPSLatitude = Pattern.compile("\\{Latitude (" + freg + "),(" + freg +
									"),(" + wreg + ")\\}");
		private Pattern senGPSLongitude = Pattern.compile("\\{Longitude (" + freg + "),(" + freg +
									"),(" + wreg + ")\\}");
		private Pattern senGPSFix = Pattern.compile("\\{Fix (" + freg + ")\\}");
		private Pattern senGPSSatellites = Pattern.compile("\\{Satellites (" + freg + ")\\}");
		// INS sensor
		private Pattern senINSLocation = Pattern.compile("\\{Location (" + freg + "),(" +
									freg + "),(" + freg + ")\\}");
		private Pattern senINSOrientation = Pattern.compile("\\{Orientation (" + freg + "),(" +
									freg + "),(" + freg + ")\\}");
		// Encoder sensor
		private Pattern senEncoders = Pattern.compile("\\{Name (" + wreg + ") Tick (" + freg + ")\\}*");
		// Touch sensor
		private Pattern senTouch = Pattern.compile("\\{Name (" + wreg + ") Touch (" + wreg + ")\\}*");
		// Ground Truth sensor
		private Pattern truePosition = Pattern.compile("\\{Location (" + freg + "),(" +
				freg + "),(" + freg + ")\\}");
		private Pattern trueOrient = Pattern.compile("\\{Orientation (" + freg + "),(" +
				freg + "),(" + freg + ")\\}");
		// Patterns for GEO messages
		private Pattern geoMain = Pattern.compile("GEO");
		private Pattern geoType = Pattern.compile("\\{Type (" + wreg + ")\\}");
		private Pattern geoName = Pattern.compile("\\{Name (" + wreg + ")\\}");
		private Pattern geoDimensions = Pattern.compile("\\{Dimensions (" + freg + "), (" +
								freg + "), (" + freg + ")\\}");
		private Pattern geoCOG = Pattern.compile("\\{COG (" + freg + "), (" +
								freg + "), (" + freg + ")\\}");
		private Pattern geoWheelRadius = Pattern.compile("\\{WheelRadius (" + freg + ")\\}");
		private Pattern geoWheelSeparation = Pattern.compile("\\{WheelSeparation (" + freg + ")\\}");
		private Pattern geoWheelBase = Pattern.compile("\\{WheelBase (" + freg + ")\\}");

		// Patterns for CONF messages
		private Pattern confMain = Pattern.compile("CONF");
		private Pattern confType = Pattern.compile("\\{Type (" + wreg + ")\\}");
		private Pattern confName = Pattern.compile("\\{Name (" + wreg + ")\\}");
		private Pattern confSteeringType = Pattern.compile("\\{SteeringType (" +
								wreg + ")\\}");
		private Pattern confMass = Pattern.compile("\\{Mass (" + freg + ")\\}");
		private Pattern confMaxSpeed = Pattern.compile("\\{MaxSpeed (" + freg + ")\\}");
		private Pattern confMaxTorque = Pattern.compile("\\{MaxTorque (" + freg + ")\\}");
		private Pattern confMaxFrontSteer = Pattern.compile("\\{MaxFrontSteer (" +
								freg + ")\\}");
		private Pattern conMaxRearSteer = Pattern.compile("\\{MaxRearSteer (" +
								freg + ")\\}");

		// Patterns for Response messages
		private Pattern resMain = Pattern.compile("RES");
		
		private String dbgMsg = "";

		public void run()
		{
			while (running)
			{
				try
				{
					handleMessage();
				}
				catch (InterruptedException e)
				{
					running = false;
					return;
				}
				catch(IllegalStateException e)
				{
					System.out.println(e.getMessage());
					System.out.println(e.getCause());
					System.out.println(dbgMsg);
				}
			}
		}

		// Function that handles the messages coming in from USARSim.
		private void handleMessage() throws InterruptedException
		{
			String msg = getLine();
			dbgMsg = msg;			
			Matcher m;
			
			/*//log the current time
			currentTime++;
			if(currentTime >= maxTimes) //reset currentTime if necessary
				currentTime = 0;
			timeLog[currentTime] = new Date();*/

			// matches STA messages
			m = staMain.matcher(msg);
			if (m.lookingAt())
			{
				// matches STA messages for GroundVehicle type
				m = staType.matcher(msg);
				m.find(0);
				if (m.group(1).equals("GroundVehicle"))
				{
					m = staTime.matcher(msg);
					m.find(0);
					STAGndVehicle.TimeStamp = Float.valueOf(m.group(1));

					m = staFrontSteer.matcher(msg);
					m.find(0);
					STAGndVehicle.FrontSteer = Float.valueOf(m.group(1));

					m = staRearSteer.matcher(msg);
					m.find(0);
					STAGndVehicle.RearSteer = Float.valueOf(m.group(1));

					m = staLightToggle.matcher(msg);
					m.find(0);
					STAGndVehicle.LightToggle = Boolean.valueOf(m.group(1));

					m = staLightIntensity.matcher(msg);
					m.find(0);
					STAGndVehicle.LightIntensity = Integer.valueOf(m.group(1));

					m = staBattery.matcher(msg);
					m.find(0);
					STAGndVehicle.BatteryLife = Integer.valueOf(m.group(1));
				}
			}

			// matches SEN messages
			m = senMain.matcher(msg);
			if (m.lookingAt())
			{
				m = senType.matcher(msg);
				m.find(0);

				if (m.group(1).equals("Sonar"))
				{
					ArrayList nameList = new ArrayList();
					ArrayList<Double> rangeList = new ArrayList<Double>();

					m = senSonars.matcher(msg);
					int index = 0;
					while (index < msg.length())
					{
						m.find(index);
						nameList.add(m.group(1));
						rangeList.add(Double.valueOf(m.group(2)));
						index = m.end();
					}
					
					double[] rangeArray = new double[rangeList.size()];
					for (int i = 0; i < rangeList.size(); i++)
					{
						Double dbl = (Double)rangeList.get(i);
						rangeArray[i] = dbl.doubleValue();
					}
					SENSonars.Name = (String[])nameList.toArray(new String[nameList.size()]);
					SENSonars.Range = rangeArray;
					
					m = time.matcher(msg);
					if(m.find())
						SENSonars.TimeStamp = Double.valueOf(m.group(1));
					
					return;
				}

				// this is for a laser range finder
				if (m.group(1).equals("RangeScanner") || m.group(1).equals("IRScanner"))
				{
					m = senName.matcher(msg);
					m.find(0);
					SENLasers.Name = m.group(1);

					m = senLaserResolution.matcher(msg);
					m.find(0);
					double res = Double.valueOf(m.group(1));

					m = senLaserFOV.matcher(msg);
					m.find(0);
					double fov = Double.valueOf(m.group(1));

					int numReadings = (int)Math.round(fov / res);
					double[] scans = new double[numReadings];

					m = senLaserScanFirst.matcher(msg);
					m.find(0);
					int index = m.end();
					scans[0] = Double.valueOf(m.group(1));

					m = senLaserScanMiddle.matcher(msg);
					for (int i = 0; i < numReadings - 1; i++)
					{
						m.find(index);
						scans[i + 1] = Double.valueOf(m.group(1));
						index = m.end();
					}

					SENLasers.Resolution = res;
					SENLasers.FieldOfView = fov;
					SENLasers.Scans = scans;

					m = time.matcher(msg);
					if(m.find())
						SENLasers.TimeStamp = Double.valueOf(m.group(1));
					
					return;
				}

				if (m.group(1).equals("Odometry"))
				{
					m = senName.matcher(msg);
					m.find(0);
					SENOdometry.Name = m.group(1);

					m = senOdometryPose.matcher(msg);
					m.find(0);
					SENOdometry.Pose = new double[] {Double.valueOf(m.group(1)), 
									Double.valueOf(m.group(2)), Double.valueOf(m.group(3))};

					m = time.matcher(msg);
					if(m.find())
						SENOdometry.TimeStamp = Double.valueOf(m.group(1));
					
					return;
				}

				if (m.group(1).equals("GPS"))
				{
					m = senName.matcher(msg);
					m.find(0);
					SENGPS.Name = m.group(1);

					m = senGPSFix.matcher(msg);
					m.find(0);
					SENGPS.GotFix = Integer.valueOf(m.group(1));

					if (SENGPS.GotFix > 0)
					{
						m = senGPSLatitude.matcher(msg);
						m.find(0);
						if (m.group(3).equals("N"))
							SENGPS.Latitude = Double.valueOf(m.group(1)) + Double.valueOf(m.group(2)) / 60;
						else
							SENGPS.Latitude = -(Double.valueOf(m.group(1)) + Double.valueOf(m.group(2)) / 60);

						m = senGPSLongitude.matcher(msg);
						m.find(0);
						if (m.group(3).equals("E"))
							SENGPS.Longitude = Double.valueOf(m.group(1)) + Double.valueOf(m.group(2)) / 60;
						else
							SENGPS.Longitude = -(Double.valueOf(m.group(1)) + Double.valueOf(m.group(2)) / 60);
					}

					m = senGPSSatellites.matcher(msg);
					m.find(0);
					SENGPS.NumSatellites = Integer.valueOf(m.group(1));

					m = time.matcher(msg);
					if(m.find())
						SENGPS.TimeStamp = Double.valueOf(m.group(1));
					
					return;
				}

				if (m.group(1).equals("INS"))
				{
					m = senName.matcher(msg);
					m.find(0);
					SENINS.Name = m.group(1);

					m = senINSLocation.matcher(msg);
					m.find(0);
					SENINS.Position = new double[] {Double.valueOf(m.group(1)), 
									Double.valueOf(m.group(2)), Double.valueOf(m.group(3))};

					m = senINSOrientation.matcher(msg);
					m.find(0);
					SENINS.Orientation = new double[] {Double.valueOf(m.group(1)),
									Double.valueOf(m.group(2)), Double.valueOf(m.group(3))};

					m = time.matcher(msg);
					if(m.find())
						SENINS.TimeStamp = Double.valueOf(m.group(1));
					
					return;
				}

				if (m.group(1).equals("Encoder"))
				{
					ArrayList nameList = new ArrayList();
					ArrayList<Integer> tickList = new ArrayList<Integer>();
					int index = 0;

					m = senEncoders.matcher(msg);
					while (index < msg.length())
					{
						m.find(index);
						nameList.add(m.group(1));
						tickList.add(Integer.valueOf(m.group(2)));
						index = m.end();
					}

					int[] tickArray = new int[tickList.size()];
					for (int i = 0; i < tickList.size(); i++)
					{
						Integer in = (Integer)tickList.get(i);
						tickArray[i] = in.intValue();
					}
					SENEncoders.Name = (String[])nameList.toArray(new String[nameList.size()]);
					SENEncoders.Ticks = tickArray;

					m = time.matcher(msg);
					if(m.find())
						SENEncoders.TimeStamp = Double.valueOf(m.group(1));
					
					return;
				}

				if (m.group(1).equals("Touch"))
				{
					ArrayList nameList = new ArrayList();
					ArrayList stateList = new ArrayList();

					m = senTouch.matcher(msg);
					int index = 0;
					while (index < msg.length())
					{
						m.find(index);
						nameList.add(m.group(1));
						stateList.add(m.group(2));
						index = m.end();
					}

					boolean[] stateArray = new boolean[stateList.size()];
					String[] stateStrings = (String[])stateList.toArray(new String[stateList.size()]);
					for (int i = 0; i < stateList.size(); i++)
					{
						stateArray[i] = Boolean.valueOf(stateStrings[i]);
					}
					SENTouch.Name = (String[])nameList.toArray(new String[nameList.size()]);
					SENTouch.State = stateArray;

					m = time.matcher(msg);
					if(m.find())
						SENTouch.TimeStamp = Double.valueOf(m.group(1));
					
					return;
				}
				
				//NOTE: you must set bAlwaysReadRFIDmem=true under 
				//RFIDSensor in USARBot.ini. Also, memory may not contain
				//spaces or punctuation besides underscore.
				if (m.group(1).equals("RFID"))
				{
					//System.out.println(msg);
					String name;
					ArrayList<Integer> IDs = new ArrayList<Integer>();
					ArrayList<String> Data = new ArrayList<String>();
					
					m = senRFIDName.matcher(msg);
					m.find();
					name = m.group(1);
					
					m = senRFID.matcher(msg);
					while (m.find())	
					{
						IDs.add(new Integer(m.group(1)));
						Data.add(m.group(2));
						//System.out.print("ID " + IDs.get(IDs.size() - 1));
						//System.out.println("\tMsg " + Data.get(Data.size() - 1));
					}
					
					int[] intID = new int[Data.size()]; 
					for(int i=0;i < Data.size();i++)
					{
						intID[i] = (int)IDs.get(i);
					}
					SENRFID.Name = name;
					SENRFID.IDs = intID;
					SENRFID.data = Data.toArray(new String[Data.size()]);

					m = time.matcher(msg);
					if(m.find())
						SENRFID.TimeStamp = Double.valueOf(m.group(1));
					
					return;
				}

				if (m.group(1).equals("GroundTruth"))
				{
					double[] orient,pos;

					m = truePosition.matcher(msg);
					m.find(0);
					SENTruth.pos = new double[] {Double.valueOf(m.group(1)), 
									Double.valueOf(m.group(2)), Double.valueOf(m.group(3))};

					m = trueOrient.matcher(msg);
					m.find(0);
					SENTruth.orient = new double[] {Double.valueOf(m.group(1)),
									Double.valueOf(m.group(2)), Double.valueOf(m.group(3))};

					m = time.matcher(msg);
					if(m.find())
						SENTruth.TimeStamp = Double.valueOf(m.group(1));
					
					return;
				}
				
				/* These are sensors that are yet to be implemented

				if (m.group(1).equals("VictSensor"))
				{
				}

				if (m.group(1).equals("HumanMotion"))
				{
				}

				if (m.group(1).equals("Sound"))
				{
				}*/

			}


			// matches MISSTA messages
			m = misstaMain.matcher(msg);
			if (m.lookingAt())
			{
				int k;
				usarMissionState state = new usarMissionState("ms1", 0.0, new int[] { 0, 0 }, new double[] { 0.0, 0.0 },
						new double[] { 0.0, 0.0 });
				
				m = misstaName.matcher(msg);
				m.find(0);
				//MISSTApackage.Name = m.group(1);
				state.Name = m.group(1);

				// Which package are we updating?
				for(k = 0;k < MISSTApackage.size(); k++){
					if(MISSTApackage.get(k).Name.equals(state.Name))
						break;
				}
				if(k == MISSTApackage.size())
					MISSTApackage.add(state);
				
				// We've selected the package to update. Now we update it
				m = misstaTime.matcher(msg);
				m.find(0);
				//MISSTApackage.TimeStamp = Double.valueOf(m.group(1));
				MISSTApackage.get(k).TimeStamp = Double.valueOf(m.group(1));

				ArrayList<Integer> linkList = new ArrayList<Integer>();
				ArrayList<Double> valueList = new ArrayList<Double>();
				ArrayList<Double> torqueList = new ArrayList<Double>();
				int index = 0;

				m = misstaLinkInfo.matcher(msg);
				while (index < msg.length())
				{
					m.find(index);
					linkList.add(Integer.valueOf(m.group(1)));
					valueList.add(Double.valueOf(m.group(2)));
					torqueList.add(Double.valueOf(m.group(3)));
					index = m.end();
				}

				int[] linkArray = new int[linkList.size()];
				double[] valueArray = new double[valueList.size()];
				double[] torqueArray = new double[torqueList.size()];
				for (int i = 0; i < linkList.size(); i++)
				{
					Integer lnk = (Integer)linkList.get(i);
					Double val = (Double)valueList.get(i);
					Double trq = (Double)torqueList.get(i);
					linkArray[i] = (int)lnk;
					valueArray[i] = (double)val;
					torqueArray[i] = (double)trq;
				}
				MISSTApackage.get(k).Link = linkArray;
				MISSTApackage.get(k).Value = valueArray;
				MISSTApackage.get(k).Torque = torqueArray;
				/*MISSTApackage.Link = linkArray;
				MISSTApackage.Value = valueArray;
				MISSTApackage.Torque = torqueArray;*/
			}

			// matches GEO messages
			m = geoMain.matcher(msg);
			if (m.lookingAt())
			{
				m = geoType.matcher(msg);
				m.find(0);
				if (m.group(1).equals("GroundVehicle"))
				{
					m = geoName.matcher(msg);
					m.find(0);
					GEOGndVehicle.Name = m.group(1);

					m = geoDimensions.matcher(msg);
					m.find(0);
					GEOGndVehicle.Dimensions = new float[] {Float.valueOf(m.group(1)), 
										Float.valueOf(m.group(2)), Float.valueOf(m.group(3))};

					m = geoCOG.matcher(msg);
					m.find(0);
					GEOGndVehicle.CenterOfGravity = new float[] {Float.valueOf(m.group(1)), 
										Float.valueOf(m.group(2)), Float.valueOf(m.group(3))};

					m = geoWheelRadius.matcher(msg);
					m.find(0);
					GEOGndVehicle.WheelRadius = Float.valueOf(m.group(1));

					m = geoWheelSeparation.matcher(msg);
					m.find(0);
					GEOGndVehicle.WheelSeparation = Float.valueOf(m.group(1));

					m = geoWheelBase.matcher(msg);
					m.find(0);
					GEOGndVehicle.WheelBase = Float.valueOf(m.group(1));
				}
			}

			/*
			// matches CONF messages
			m = confMain.matcher(msg);
			if (m.lookingAt())
			{
			}
			
			// matches RES messages
			m = resMain.matcher(msg);
			if (m.lookingAt())
			{
				System.out.println(msg);
			}//*/
			 
		}

		// Gets the next input line delimited by a \r\n sequence. This
		// function maintains the class' [inMessage] field.
		private String getLine()
		{
			while (true)
			{
				int pos = inMessage.indexOf("\r\n");
				//int pos = buffer.indexOf("\r\n");
				if (pos == -1)
				{
					String nextChunk;
					try
					{
						nextChunk = getMoreData();
					}
					catch (IOException e)
					{
						return String.valueOf(e);
					}

					if (null == nextChunk)
					{
						// No more data!
						return new String();
					}
					else
					{
						inMessage.append(nextChunk);
						//buffer.append(nextChunk);
					}
				}
				else
				{
					//String line = buffer.substring(0, pos);
					//buffer.delete(0, pos + 2);
					String line = inMessage.substring(0, pos);
					inMessage.delete(0, pos + 2);
					return line;
				}
			}
		}

		// Gets a chunk of new data from USARSim.
		private String getMoreData() throws IOException
		{
			byte[] buffMsg = new byte[bufferChunk];
			int bytes_read = 0;

			while (bytes_read < bufferChunk && running)
			{
				int c = byteReader.read(buffMsg, bytes_read, bufferChunk - bytes_read);
				if (c > 0)
					bytes_read += c;
				else
				{
					System.out.println("No data coming in on the socket!\n\tParseWorker will stop running now...");
					running = false;
				}
			}
			String value = new String(buffMsg);
			return value;
			/*if (testIndex == testData.length())
			{
				return null;
			}
			else
			{
				int len = Math.min(testData.length() - testIndex, chunkSize);
				String chunk = testData.substring(testIndex, testIndex + len);
				testIndex += len;
				return chunk;
			}*/
		}

	}

	public void sendQueryCmd(String queryType, String typeName) throws IOException
	{
		String cmd;

		cmd = queryType;
		cmd += " {Type " + typeName + "}";
		writeMsg(cmd);
	}

	// Sends the message to USARSim
	public void writeMsg(String msg) throws IOException
	{
		msg += "\r\n";
		this.writer.write(msg);
		this.writer.flush();
	}

	public void skidSteerDrive(float left, float right, boolean normalized, boolean light, boolean flip) throws IOException
	{
		String msg = "DRIVE {Left " + left + "} {Right " + right + "} {Normalized false} ";
		if (normalized)
		{
			left = Math.max(-100, Math.min(100, left));
			right = Math.max(-100, Math.min(100, right));
			msg = "DRIVE {Left " + left + "} {Right " + right + "} {Normalized true} ";
		}
		
		if (light)
			msg += "{Light true} ";

		if (flip)
			msg += "{Flig true} ";

		writeMsg(msg);
	}

	public void ackermanDrive(float speed, float front, float rear, boolean normalized, boolean light, boolean flip) throws IOException
	{
		String msg = "DRIVE {Speed " + speed + "} {FrontSteer " + front + "} {RearSteer " + rear + 
								"} {Normalized false} ";
		if (normalized)
		{
			speed = Math.max(-100, Math.min(100, speed));
			front = Math.max(-100, Math.min(100, front));
			rear = Math.max(-100, Math.min(100, rear));
			msg = "DRIVE {Speed " + speed + "} {FrontSteer " + front + "} {RearSteer " + rear + 
								"} {Normalized true} ";
		}

		if (light)
			msg += "{Light true} ";

		if (flip)
			msg += "{Flig true} ";

		writeMsg(msg);
	}
	
	public void aerialDrive(float Altitude, float Linear, float Lateral, float Rotational, boolean normalized) throws IOException
	{
		String msg = "DRIVE {AltitudeVelocity " + Altitude + "} {LinearVelocity " + Linear + "} {LateralVelocity " + Lateral + "} {RotationalVelocity " + Rotational + "} {Normalized false} ";
		if (normalized)
		{
			Altitude = Math.max(-100, Math.min(100, Altitude));
			Linear = Math.max(-100, Math.min(100, Linear));
			Lateral = Math.max(-100, Math.min(100, Lateral));
			Rotational = Math.max(-100, Math.min(100, Rotational));
				
			msg = "DRIVE {AltitudeVelocity " + Altitude + "} {LinearVelocity " + Linear + "} {LateralVelocity " + Lateral + "} {RotationalVelocity " + Rotational + "} {Normalized true} ";
		}

		writeMsg(msg);
	}
	
    public void sendGoto(String PathName) throws IOException
	{
		String msg = "GOTO {Name " + PathName + "} ";

		writeMsg(msg);
	}
	
	public void sendRaw(String Raw) throws IOException
	{
		String msg = Raw;

		writeMsg(msg);
	}
	
	/*public void send_motorCommand(int left_motor, int right_motor, int duration) throws IOException, Exception
	{
		left_motor = Math.max(-100, Math.min(100, left_motor));
		right_motor = Math.max(-100, Math.min(100, right_motor));
		String msg = "DRIVE {Left " + left_motor + "} {Right " + right_motor + "} {Normalized True}";
		writeMsg(msg);
		duration = Math.max(0, Math.min(255, duration));
		Thread.sleep(duration * 10);
		if (duration > 0)
			msg = "DRIVE {Left " + 0 + "} {Right " + 0 + "} {Normalized True}";
		writeMsg(msg);
	}
	*/
    public void send_MisPkgCommand(String name, int[] link, float[] value, int[] order) throws IOException, Exception
    {
		int n;
		int length = Math.min(Math.min(link.length, value.length), order.length);
        String msg = "MISPKG {Name " + name + "}";
		for(n=0;n<length;n++){
			msg += " {Link " + link[n] + "} {Value " + value[n] + "} {Order " + order[n] + "}";
		}
        writeMsg(msg);
    }
    
    public void setRFIDData(String name,int tagID,String data) throws IOException{
    	String msg = "SET {Type RFID} {Name " + name + "} {Opcode Write} {Params " + tagID + " " + data + "}";
    	writeMsg(msg);
    }
}

//*************************************************************************

// Helper method that will discard any pending input bytes.
	/*
		private void discard_input() throws IOException
		{
			if (this.byteReader.available() > 0)
			{
				// If there's any junk in there, clear it out.
				int av = this.byteReader.available();
				byte[] buffer = new byte[256];
				while (av > 0)
				{
					this.byteReader.read(buffer, 0, buffer.length > av ? av : buffer.length);
					av = this.byteReader.available();
				}
			}
		}
    
    static int bytesize = 600;
    static String given = "";
    static int numbersens = 0;

    public void setSize(int a)
    {
        bytesize = a;
    }

    String linereader = "";

    private String retrieve() throws IOException
    {
        given = "";

        int c;
        int bytes_read = 0;
        byte[] testbytes = new byte[bytesize];
        this.discard_input();
        while(bytes_read < bytesize)
        {
            c = this.byteReader.read(testbytes, bytes_read, bytesize - bytes_read);
            if(c > 0)
                bytes_read += c;
        }
        for(int k = 0; k < bytesize; k++)
            given += (char) testbytes[k];

        given = given.substring(0, given.lastIndexOf("\n") + 1);
        return given;
    }

   int supertest = 0;
    String lineused = "";
    double[] testarray = new double[10];
    public double[] sensor(String sensortype) throws IOException
    {
        this.retrieve();
        if(sensortype.equalsIgnoreCase("ins"))
        {
            double[] array = new double[6];
            String onepart = "";
            String twopart = "";

            lineused = given.substring(given.lastIndexOf("Type INS"), given.indexOf("\n", given.lastIndexOf("Type INS")));
            onepart = lineused.substring(lineused.indexOf("Location") + 9, lineused.indexOf("}", lineused.indexOf("Location")));
            twopart = lineused.substring(lineused.indexOf("Orientation") + 12, lineused.indexOf("}", lineused.indexOf("Orientation")));

            array[0] = Double.parseDouble(onepart.substring(0, onepart.indexOf(",")));
            array[1] = Double.parseDouble(onepart.substring(onepart.indexOf(",") + 1, onepart.lastIndexOf(",")));
            array[2] = Double.parseDouble(onepart.substring(onepart.lastIndexOf(",") + 1, onepart.length()));
            array[3] = Double.parseDouble(twopart.substring(0, twopart.indexOf(",")));
            array[4] = Double.parseDouble(twopart.substring(twopart.indexOf(",") + 1, twopart.lastIndexOf(",")));
            array[5] = Double.parseDouble(twopart.substring(twopart.lastIndexOf(",") + 1, twopart.length()));

            return array;
        }
        else if(sensortype.equalsIgnoreCase("encoder"))
        {
            String tuper = "";

            lineused = given.substring(given.lastIndexOf("Type Encoder"), given.indexOf("\n", given.lastIndexOf("Type Encoder")));
            for(int k = 0; k < lineused.length() - 7; k++)
            {
                if(lineused.substring(k, k + 4).equals("Name"))
                    tuper = tuper + lineused.substring(k + 5, lineused.indexOf(" ", k + 5)) + " = ";
                else if(lineused.substring(k, k + 4).equals("Tick"))
                    tuper = tuper + lineused.substring(k + 5, lineused.indexOf("}", k + 5)) + "\n";
            }

            //return "Encoder sensor data:\n" + tuper;
			//return tuper;
        }
        else if(sensortype.equalsIgnoreCase("touch"))
        {
            String outsult = "";

            lineused = given.substring(given.lastIndexOf("Type Touch"), given.indexOf("\n", given.lastIndexOf("Type Touch")));
            for(int k = 0; k < lineused.length() - 11; k++)
            {
                if(lineused.substring(k, k + 4).equals("Name"))
                    outsult = outsult + lineused.substring(k + 5, lineused.indexOf(" ", k + 5)) + " = ";
                else if(lineused.substring(k, k + 6).equals("Touch "))
                    outsult = outsult + lineused.substring(k + 6, lineused.indexOf("}", k + 6)) + "\n";
            }

            //return "Touch sensor data:\n" + outsult;
			//return outsult;
        }
        else if(sensortype.equalsIgnoreCase("humanmotion"))
        {
            String tlustuo = "";

            lineused = given.substring(given.lastIndexOf("HumanMotion"), given.indexOf("\n", given.lastIndexOf("HumanMotion")));
            for(int k = 0; k < lineused.length() - 10; k++)
            {
                if(lineused.substring(k, k + 4).equals("Prob"))
                    tlustuo = lineused.substring(k + 5, k + 9);
            }

            //return "Human Motion Detection:\nProbability = " + tlustuo;
			//return tlustuo;
        }
        else if(sensortype.equalsIgnoreCase("sound"))
        {
            String reput = "";

            lineused = given.substring(given.lastIndexOf("Type Sound"), given.indexOf("\n", given.lastIndexOf("Type Sound")));
            for(int k = 0; k < lineused.length() - 17; k++)
            {
                if(lineused.substring(k, k + 8).equals("Loudness"))
                    reput = reput + lineused.substring(k + 9, lineused.indexOf("}", k + 9)) + "\n";
            }

            //return "Sound sensor data:\n" + reput;
			//return reput;
        }

        return testarray;
    }
    */
//*************************************************************************