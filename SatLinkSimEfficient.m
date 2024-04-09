%% NOTE: NOT WORKING! 
%% This will be much faster to execute when finished but is incomplete

clear;

%for building simulated connection graphs between sats and groundstations for given
%time windows.


%Change variables in this section for different sim params
%===========================================================================
startTime = datetime(2023,7,11,16,30,0);  % year, month, date, hour, minute, second (In UTC)
SimLength = hours(6);
                       
sampleTime = 60; %Sim time resolution in seconds
numSatsCeiling = 3;  %If this is smaller than number of sats in TLE, only consider this number (all sats still appear in viewer) 
targetSat = 1;  %Chack if path exists from target to each other sat. 1 = GS, otherwise Sat number +1 

%Uncomment desired TLE

%tleFile = "leoSatelliteConstellation.tle";
%tleFile = "leoSatelliteConstellation1.tle"; 
tleFile = "leoSatelliteConstellation4.tle";
%tleFile = "leoSatelliteConstellation8.tle";
%tleFile = 'threeSatelliteConstellationE.tle';
%tleFile = 'Walker.tle';
%==================================================================



stopTime = startTime + SimLength;
sc = satelliteScenario(startTime,stopTime,sampleTime);

sat = satellite(sc,tleFile);
totalTime = round(seconds(stopTime - startTime)/sampleTime);



latitude = -33.7974039;        % degrees
longitude = 151.1768208;       % degrees
gs1 = groundStation(sc, ...
    latitude, ...
    longitude, ...
    "Name","Ground Station");


totalNodes = length(sat)+1;
satAcc(totalNodes,totalNodes) = 0;

    ac = access(sat(2),gs1);
    intvls = accessIntervals(ac)

    intSize = size(intvls);

    intvStart = intvls.StartTime(1)
    intvStop= intvls.EndTime(1)

timeArray(startTime:stopTime) = 0;

for i = intvStart:intvStop
    
end

% for i=1:totalNodes
%     ac = access(sat(1),gs1);
%     intvls = accessIntervals(ac);
% 
% end

%Comment next line for faster runtime
%satelliteScenarioViewer(sc);

