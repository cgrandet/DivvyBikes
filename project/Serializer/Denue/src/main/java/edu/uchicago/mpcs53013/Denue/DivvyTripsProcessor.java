package edu.uchicago.mpcs53013.Denue;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.GZIPInputStream;

import edu.uchicago.mpcs53013.DivvyTrips.DivvyTrips;


public abstract class DivvyTripsProcessor {
	static class MissingDataException extends Exception {

	    public MissingDataException(String message) {
	        super(message);
	    }

	    public MissingDataException(String message, Throwable throwable) {
	        super(message, throwable);
	    }

	}
	
	static double tryToReadMeasurement(String name, String s, String missing) throws MissingDataException {
		if(s.equals(missing))
			throw new MissingDataException(name + ": " + s);
		return Double.parseDouble(s.trim());
	}

	void processLine(String[] line_tuple, File file) throws IOException {
		try {
			processDivvyTrips(tripFromLine(line_tuple), file);
		} catch(MissingDataException e) {
			// Just ignore lines with missing data
		}
	}

	abstract void processDivvyTrips(DivvyTrips summary, File file) throws IOException;
	BufferedReader getFileReader(File file) throws FileNotFoundException, IOException {
		if(file.getName().endsWith(".csv"))
			return new BufferedReader
					     (new InputStreamReader
					    				 (new FileInputStream(file)));
		return new BufferedReader(new InputStreamReader(new FileInputStream(file)));
	}
	
	void processNoaaFile(File file) throws IOException {	
		System.out.println(file);
		BufferedReader br = getFileReader(file);
		String line = null; // Discard header;
		int count = 0;
		while((line = br.readLine()) != null) {
			if(count != 0) { // count == 0 means the first line
		        String[] line_tuple = line.split(",");
		        processLine(line_tuple, file);
			}
			count++;
		}
	}

	void processNoaaDirectory(String directoryName) throws IOException {
		File directory = new File(directoryName);
		File[] directoryListing = directory.listFiles();
		for(File noaaFile : directoryListing)
			processNoaaFile(noaaFile);
	}
	
	DivvyTrips tripFromLine(String[] line_tuple) throws NumberFormatException, MissingDataException {
		Integer tripID = Integer.parseInt(line_tuple[0].trim());
		String startdate = (line_tuple[1].trim());
		String pattern = "(\\d+)/(\\d+)/(\\d+) (\\d+):(\\d+)";
		Pattern r = Pattern.compile(pattern);
		Matcher m = r.matcher(startdate);
		m.find();
		Integer startday = Integer.parseInt(m.group(2));
		Integer startmonth = Integer.parseInt(m.group(1));
		Integer startyear = Integer.parseInt(m.group(3));
		Integer starthour = Integer.parseInt(m.group(4));
		Integer startminute = Integer.parseInt(m.group(5));
		String enddate = (line_tuple[2].trim());
		Matcher m_a = r.matcher(enddate);
		m_a.find();
		Integer endday = Integer.parseInt(m_a.group(2));
		Integer endmonth = Integer.parseInt(m_a.group(1));
		Integer endyear = Integer.parseInt(m_a.group(3));
		Integer endhour = Integer.parseInt(m_a.group(4));
		Integer endminute = Integer.parseInt(m_a.group(5));
		Integer bicycleID = Integer.parseInt(line_tuple[3].trim());
		Integer tripduration = Integer.parseInt(line_tuple[4].trim());
		Integer fromstationID = Integer.parseInt(line_tuple[5].trim());
	    String fromstationname = line_tuple[6].trim();
	    Integer tostationID = Integer.parseInt(line_tuple[7].trim());
		String tostationname = line_tuple[8].trim();
		String usertype = line_tuple[9].trim();
		//Boolean gender = line_tuple[10].trim() == "Female";
	    //Integer birthyear = Integer.parseInt(line_tuple[11].trim());
		
		DivvyTrips summary 
			= new DivvyTrips(tripID,startday, startmonth, startyear, starthour, startminute,
					         endday,endmonth,endyear,endhour,endminute,bicycleID,tripduration,
					          fromstationID,fromstationname,tostationID,tostationname,usertype);
		return summary;
	}

}
