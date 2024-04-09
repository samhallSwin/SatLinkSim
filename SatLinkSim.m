clear;

%for building simulated connection graphs between sats and groundstations for given
%time windows.


%Change variables in this section for different sim params
%===========================================================================
startTime = datetime(2023,7,11,16,30,0);  % year, month, date, hour, minute, second (In UTC)
SimLength = hours(2);
                       
sampleTime = 600; %Sim time resolution in seconds
numSatsCeiling = 3;  %If this is smaller than number of sats in TLE, only consider this number (all sats still appear in viewer) 
targetSat = 1;  %Chack if path exists from target to each other sat. 1 = GS, otherwise Sat number +1 

%Uncomment desired TLE

%tleFile = "TLEs\leoSatelliteConstellation.tle";
%tleFile = "TLEs\leoSatelliteConstellation1.tle"; 
%tleFile = "TLEs\leoSatelliteConstellation4.tle";
%tleFile = "TLEs\leoSatelliteConstellation8.tle";
tleFile = 'TLEs\threeSatelliteConstellationE.tle';
%tleFile = 'TLEs\Walker.tle';
%==================================================================



stopTime = startTime + SimLength;
sc = satelliteScenario(startTime,stopTime,sampleTime);

sat = satellite(sc,tleFile);


if length(sat) > numSatsCeiling 
    sat((numSatsCeiling+1):length(sat)) = [];
end

%Comment next line for faster runtime
satelliteScenarioViewer(sc);


latitude = -33.7974039;        % degrees
longitude = 151.1768208;       % degrees
gs1 = groundStation(sc, ...
    latitude, ...
    longitude, ...
    "Name","Ground Station");

    ac = access(sat(1),gs1);
    intvls = accessIntervals(ac);

totalNodes = length(sat)+1;
satAcc(totalNodes,totalNodes) = 0;


totalTime = round(seconds(stopTime - startTime)/sampleTime);
time = startTime;
timeIncArray(1:totalTime) = time;

connectArray(1:totalTime,totalNodes) = 0;

satAccTime(1:4,1:4,1:totalTime) = 0;

%Create name vector for populating Graphs
NodesName(1) = {'gs'};
for numsats = 1: length(sat)
    str = ['sat' num2str(numsats)];
    NodesName(numsats+1) = {str};
end

for timeInc = 1:totalTime
    
    timeIncArray(timeInc) = time;
    %check GS to each sat
    for j = 2:totalNodes
        ac = access(gs1,sat(j-1));
        satAcc(1,j) = accessStatus(ac,time);
        satAcc(j,1) = satAcc(1,j);
    end

    %adj matrix between sats
    for i = 2:totalNodes
        for j = 2:totalNodes
            if i==j
               satAcc(i,j)=0;
            else
                ac = access(sat(i-1),sat(j-1));
                satAcc(i,j) = accessStatus(ac,time);
            end
            %intvls = accessIntervals(ac)
        end
    end

    G= graph(satAcc,NodesName);

    comp = conncomp(G);
    
    %Check connections between target node and each other node for
    %visualising
    for iNodes = 1:totalNodes
        if (comp(targetSat) == comp(iNodes)) && (iNodes ~= targetSat)
            connectArray(timeInc,iNodes) = 1;
        end
    end
    
    
    %Store for each time interval
    Garray{timeInc} = G;
    compArray(:,timeInc)=comp;    

    %satAccTime(:,:,timeInc) = satAcc;
    time = time + seconds(sampleTime);
    sprintf('Simulating time interval %s', string(time))
    
end
figure
%imagesc(connectArray');
spy(connectArray','ro');
grid on
