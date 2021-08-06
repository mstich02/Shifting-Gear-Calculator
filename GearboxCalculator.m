% These are entered to delete the matricies from previous tests, and thus
% increase efficeny of MATLAB script.
clear
clc

% This is the required user inputs needed to find a gear ratio within a
% range
% This optimizes for efficency, then sorts based on desired rpm.

    Weight=input('Input Robot Weight (lbs): ');
    Motors=input('Input Ammount of Drive Motors: ');
    WheelSize=input('Type in Wheel Diameter (in): ');
    Speed=input('Input Target Speed (f/s): ');
    COF=input('Input Kinetic Coeffiect of Friction: ');
    Error=input('Input Error Range Percentage: ');
    
while ((Weight>0) && (Motors>0) && (WheelSize>0) && (Speed>0) && (COF>0) && (Error>0))==0
    disp('Error, one number was less than or equal to zero');
    Weight=input('Input Robot Weight (lbs): ');
    Motors=input('Input Ammount of Drive Motors: ');
    WheelSize=input('Type in Wheel Diameter (in): ');
    Speed=input('Input Target Speed (f/s): ');
    COF=input('Input Kinetic Coeffiect of Friction: ');
    Error=input('Input Error Range Percentage: ');
end


% This calculates the max force a robot can output at a specified weight
% and Coeffiecent of friction

WeightN=WeightFun(Weight);
Mass=MassFun(WeightN);
MaxAppliedKineticForce=COF*WeightN;
MaxAppliedKineticForceHigh=MaxAppliedKineticForce*(1+Error/100);


%Target Veleocity Calculations
%The Goal is to output different gear and motor combinations that the top
%velocity is within a spesified standard error range. 

WheelCircumfrence=pi*WheelSize/12;
WheelRadiusMeters=WheelSize/2*.0254;
TargetRPM=(Speed*60)/WheelCircumfrence;
TargetRPMHigh=TargetRPM*(1+Error/100);
TargetRPMLow=TargetRPM*(1-Error/100);
Torque=(MaxAppliedKineticForce*WheelRadiusMeters)/Motors;


%--------------------------------------------------------------------------

%Comparison
%This section Takes the motor curves and multiplies it by the ratio data to
%get a matrix of 490x100 this then takes the new data and compairs it to
%the theoretical desired limits the user inputed 

Falcon=fopen('Falcon500MotorCurveData.csv','r');
RatiosFalcon=fopen('Ratios.csv');
RatiosFalconData=textscan(RatiosFalcon,'%s %s %s %f %f','Delimiter',',');
FalconData=textscan(Falcon,'%f %f %*f %*f %*f %f %*f','Delimiter',',');
FalconRPM=(FalconData{1}).*(RatiosFalconData{5}');
FalconTorque=(FalconData{2})./(RatiosFalconData{4}');
[FalconRow,FalconColumn]=find((FalconTorque>Torque) & (FalconTorque<(Torque*(1+Error/100))) & (FalconRPM<TargetRPMHigh) & FalconRPM>TargetRPMLow);
fclose('all');

Neo=fopen('Neo_MotorCurve-12V.csv','r');
RatiosNeo=fopen('Ratios.csv');
RatiosNeoData=textscan(RatiosNeo,'%s %s %s %f %f','Delimiter',',');
NeoData=textscan(Neo,'%f %f %*f %*f %*f %f %*f','Delimiter',',');
NeoRPM=(NeoData{1}).*(RatiosNeoData{5}');
NeoTorque=(NeoData{2})./(RatiosNeoData{4}');
[NeoRow,NeoColumn]=find((NeoTorque>Torque) & (NeoTorque<(Torque*(1+Error/100))) & (NeoRPM<TargetRPMHigh) & NeoRPM>TargetRPMLow);
fclose('all');

CIM=fopen('CIM-MotorCurve-12v.csv','r');
RatiosCIM=fopen('Ratios.csv');
RatiosCIMData=textscan(RatiosCIM,'%s %s %s %f %f','Delimiter',',');
CIMData=textscan(CIM,'%f %f %*f %*f %*f %f %*f','Delimiter',',');
CIMRPM=(CIMData{1}).*(RatiosCIMData{5}');
CIMTorque=(CIMData{2})./(RatiosCIMData{4}');
[CIMRow,CIMColumn]=find((CIMTorque>Torque) & (CIMTorque<(Torque*(1+Error/100))) & (CIMRPM<TargetRPMHigh) & CIMRPM>TargetRPMLow);
fclose('all');

MiniCIM=fopen('MiniCIM-MotorCurve-12v.csv','r');
RatiosMiniCIM=fopen('Ratios.csv');
RatiosMiniCIMData=textscan(RatiosMiniCIM,'%s %s %s %f %f','Delimiter',',');
MiniCIMData=textscan(MiniCIM,'%f %f %*f %*f %*f %f %*f','Delimiter',',');
MiniCIMRPM=(MiniCIMData{1}).*(RatiosMiniCIMData{5}');
MiniCIMTorque=(MiniCIMData{2})./(RatiosMiniCIMData{4}');
[MiniCIMRow,MiniCIMColumn]=find((MiniCIMTorque>Torque) & (MiniCIMTorque<(Torque*(1+Error/100))) & (MiniCIMRPM<TargetRPMHigh) & MiniCIMRPM>TargetRPMLow);
fclose('all');

%--------------------------------------------------------------------------

%Display Statements
%This section prints all of the motor ratios with their motors that falls
%within the desired criteria set by the user. 

disp(' ')
fprintf('Falcon Ratios--------------------------------------\n')
fprintf('                          Velocity Torque Efficency\n')
for count1=1:length(FalconColumn)
    fprintf('%d %+6s %+6s %+5s  |%7.2f %7.2f %7.2f\n', count1, RatiosFalconData{1}{FalconColumn(count1)}, RatiosFalconData{2}{FalconColumn(count1)}, RatiosFalconData{3}{FalconColumn(count1)},WheelCircumfrence/60*FalconRPM(FalconRow(count1),FalconColumn(count1)),FalconData{2}(FalconRow(count1)),FalconData{3}(FalconRow(count1)))
end

disp(' ')
fprintf('Neo Ratios-----------------------------------------\n')
fprintf('                          Velocity Torque Efficency\n')
for count1=1:length(NeoColumn)
    fprintf('%d %+6s %+6s %+5s  |%7.2f %7.2f %7.2f\n', count1, RatiosNeoData{1}{NeoColumn(count1)}, RatiosNeoData{2}{NeoColumn(count1)}, RatiosNeoData{3}{NeoColumn(count1)},WheelCircumfrence/60*NeoRPM(NeoRow(count1),NeoColumn(count1)),NeoData{2}(NeoRow(count1)),NeoData{3}(NeoRow(count1)))
end

disp(' ')
fprintf('CIM Ratios-----------------------------------------\n')
fprintf('                          Velocity Torque Efficency\n')
for count1=1:length(CIMColumn)
    fprintf('%-d %+6s %+6s %+5s  |%7.2f %7.2f %7.2f\n', count1, RatiosCIMData{1}{CIMColumn(count1)}, RatiosCIMData{2}{CIMColumn(count1)}, RatiosCIMData{3}{CIMColumn(count1)},WheelCircumfrence/60*CIMRPM(CIMRow(count1),CIMColumn(count1)),CIMData{2}(CIMRow(count1)),CIMData{3}(CIMRow(count1)))
end

disp(' ')
fprintf('MiniCIM Ratios-------------------------------------\n')
fprintf('                          Velocity Torque Efficency\n')
for count1=1:length(MiniCIMColumn)
    fprintf('%d %+6s %+6s %+5s  |%7.2f %7.2f %7.2f\n', count1, RatiosMiniCIMData{1}{MiniCIMColumn(count1)}, RatiosMiniCIMData{2}{MiniCIMColumn(count1)}, RatiosMiniCIMData{3}{MiniCIMColumn(count1)},WheelCircumfrence/60*MiniCIMRPM(MiniCIMRow(count1),MiniCIMColumn(count1)),MiniCIMData{2}(MiniCIMRow(count1)),MiniCIMData{3}(MiniCIMRow(count1)))
end

%--------------------------------------------------------------------------

% Selection File

%This part asks the user what motor and what ratio they want to be plotted
%to see the amps drawn, torque, and efficency plotted on three seperate rpm
%graphs

Selection=input('Which Motor would you like? ','s');
SelectionNum=input('What is the ratio number? ');
SelectionAlt=lower(Selection);

count1=1;
Falcon=fopen('FalconMAT.csv','w');
while count1<=length(FalconColumn)
    fprintf(Falcon,'%d %s %s %s %f %f %f\n', count1, RatiosFalconData{1}{FalconColumn(count1)}, RatiosFalconData{2}{FalconColumn(count1)}, RatiosFalconData{3}{FalconColumn(count1)},FalconRPM(FalconRow(count1),FalconColumn(count1)),FalconData{2}(FalconRow(count1)),FalconData{3}(FalconRow(count1)));
    count1=count1+1;
end
Neo=fopen('NeoMAT.csv','w');
for count1=1:length(NeoColumn)
    fprintf(Neo,'%d %s %s %s %f %f %f\n', count1, RatiosNeoData{1}{NeoColumn(count1)}, RatiosNeoData{2}{NeoColumn(count1)}, RatiosNeoData{3}{NeoColumn(count1)},NeoRPM(NeoRow(count1),NeoColumn(count1)),NeoData{2}(NeoRow(count1)),NeoData{3}(NeoRow(count1)));
end
CIM=fopen('CIMMAT.csv','w');
for count1=1:length(CIMColumn)
    fprintf(CIM,'%d %s %s %s %f %f %f\n', count1, RatiosCIMData{1}{CIMColumn(count1)}, RatiosCIMData{2}{CIMColumn(count1)}, RatiosCIMData{3}{CIMColumn(count1)},CIMRPM(CIMRow(count1),CIMColumn(count1)),CIMData{2}(CIMRow(count1)),CIMData{3}(CIMRow(count1)));
end
MiniCIM=fopen('MiniCIMMAT.csv','w');
for count1=1:length(MiniCIMColumn)
    fprintf(MiniCIM,'%d %s %s %s %f %f %f\n', count1, RatiosMiniCIMData{1}{MiniCIMColumn(count1)}, RatiosMiniCIMData{2}{MiniCIMColumn(count1)}, RatiosMiniCIMData{3}{MiniCIMColumn(count1)},MiniCIMRPM(MiniCIMRow(count1),MiniCIMColumn(count1)),MiniCIMData{2}(MiniCIMRow(count1)),MiniCIMData{3}(MiniCIMRow(count1)));
end
fclose('all');

% Graphing Portion
%This Graphs the data onto three RPM subgraphs with the y axis being
%torque, efficency, and motor amp draw. 
if strcmp('falcon',SelectionAlt)==1
    Falcon=fopen('Falcon500MotorCurveData.csv');
    FalconData=textscan(Falcon,'%f %f %f %f %*f %f %f','Delimiter',',');
    FalconMAT=fopen('FalconMAT.csv');
    FalconMATData=textscan(FalconMAT,'%f %s %s %s %f %f %f','Delimiter',' ');
        row=find(FalconData{5}==(FalconMATData{7}(SelectionNum)));
        x2=FalconData{1}(row);
        subplot(3,1,1)
        hold on
        x=FalconData{1};
        y1=FalconData{2};
        plot(x,y1);
        title('Torque')
        ylabel('(N*m)')
        y1a=0:.01:max(FalconData{2});
        plot(x2,y1a, '.r', 'MarkerSize', 5);

        subplot(3,1,2)
        hold on
        y2=FalconData{3};
        plot(x,y2, 'k--');
        title('Current')
        ylabel('(A)')
        xlabel('(RPM)')
        y2a=0:.1:max(FalconData{3});
        plot(x2,y2a, '.r', 'MarkerSize', 5);

        subplot(3,1,3)
        hold on
        y3=FalconData{5};
        plot(x,y3, 'k--');
        title('Efficency')
        ylabel('(%)')
        y3a=0:.1:max(FalconData{5});
        plot(x2,y3a, '.r', 'MarkerSize', 5);

elseif strcmp('neo',SelectionAlt)==1
    
    Neo=fopen('Neo_MotorCurve-12V.csv');
    NeoData=textscan(Neo,'%f %f %f %*f %*f %f %f','Delimiter',',');
    NeoMAT=fopen('NeoMAT.csv');
    NeoMATData=textscan(NeoMAT,'%*f %*s %*s %*s %*f %*f %f','Delimiter',' ');
        row=find(NeoData{4}==(NeoMATData{1}(SelectionNum)));
        x2=NeoData{1}(row);
        subplot(3,1,1)
        hold on
        x=NeoData{1};
        y1=NeoData{2};
        plot(x,y1);
        title('Torque')
        ylabel('(N*m)')
        y1a=0:.01:max(NeoData{2});
        plot(x2,y1a, '.r', 'MarkerSize', 5);

        subplot(3,1,2)
        hold on
        y2=NeoData{3};
        plot(x,y2, 'k--');
        title('Current')
        ylabel('(A)')
        xlabel('(RPM)')
        y2a=0:.1:max(NeoData{3});
        plot(x2,y2a, '.r', 'MarkerSize', 5);

        subplot(3,1,3)
        hold on
        y3=NeoData{4};
        plot(x,y3, 'k--');
        title('Efficency')
        ylabel('(%)')
        y3a=0:.1:max(NeoData{4});
        plot(x2,y3a, '.r', 'MarkerSize', 5);

elseif strcmp('cim',SelectionAlt)==1
    CIM=fopen('CIM-MotorCurve-12v.csv');
    CIMData=textscan(CIM,'%f %f %f %f %*f %f %f','Delimiter',',');
    CIMMAT=fopen('CIMMAT.csv');
    CIMMATData=textscan(CIMMAT,'%f %s %s %s %f %f %f','Delimiter',' ');
        row=find(CIMData{5}==(CIMMATData{7}(SelectionNum)));
        x2=CIMData{1}(row);
        subplot(3,1,1)
        hold on
        x=CIMData{1};
        y1=CIMData{2};
        plot(x,y1);
        title('Torque')
        ylabel('(N*m)')
        y1a=0:.01:max(CIMData{2});
        plot(x2,y1a, '.r', 'MarkerSize', 5);

        subplot(3,1,2)
        hold on
        y2=CIMData{3};
        plot(x,y2, 'k--');
        title('Current')
        ylabel('(A)')
        xlabel('(RPM)')
        y2a=0:.1:max(CIMData{3});
        plot(x2,y2a, '.r', 'MarkerSize', 5);

        subplot(3,1,3)
        hold on
        y3=CIMData{5};
        plot(x,y3, 'k--');
        title('Efficency')
        ylabel('(%)')
        y3a=0:.1:max(CIMData{5});
        plot(x2,y3a, '.r', 'MarkerSize', 5);
elseif strcmp('minicim',SelectionAlt)==1
    MiniCIM=fopen('MiniCIM-MotorCurve-12v.csv');
    MiniCIMData=textscan(MiniCIM,'%f %f %f %f %*f %f %f','Delimiter',',');
    MiniCIMMAT=fopen('MiniCIMMAT.csv');
    MiniCIMMATData=textscan(MiniCIMMAT,'%f %s %s %s %f %f %f','Delimiter',' ');
        row=find(MiniCIMData{5}==(MiniCIMMATData{7}(SelectionNum)));
        x2=MiniCIMData{1}(row);
        subplot(3,1,1)
        hold on
        x=MiniCIMData{1};
        y1=MiniCIMData{2};
        plot(x,y1);
        title('Torque')
        ylabel('(N*m)')
        y1a=0:.01:max(MiniCIMData{2});
        plot(x2,y1a, '.r', 'MarkerSize', 5);

        subplot(3,1,2)
        hold on
        y2=MiniCIMData{3};
        plot(x,y2, 'k--');
        title('Current')
        ylabel('(A)')
        xlabel('(RPM)')
        y2a=0:.1:max(MiniCIMData{3});
        plot(x2,y2a, '.r', 'MarkerSize', 5);

        subplot(3,1,3)
        hold on
        y3=MiniCIMData{5};
        plot(x,y3, 'k--');
        title('Efficency')
        ylabel('(%)')
        y3a=0:.1:max(MiniCIMData{5});
        plot(x2,y3a, '.r', 'MarkerSize', 5);
end    