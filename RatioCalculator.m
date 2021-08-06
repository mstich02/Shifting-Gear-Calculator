Ratio1={
    '8:62' 8/62
    '9:62' 9/62
    '10:60' 10/60
    '11:60' 11/60
    '12:60' 12/60
    '13:58' 13/58
    '14:58' 14/68};
Ratio2={
    '16:40' 16/40
    '18:38' 18/38
    '20:36' 20/36
    '22:34' 22/34
    '24:32' 24/32
    '26:30' 26/30
    '28:28' 28/28};
Spread={
    '1.28' 'High' 36/30 'Low' 32/34
    '1.30' 'High' 26/40 'Low' 22/44
    '1.38' 'High' 36/40 'Low' 26/40
    '1.45' 'High' 32/34 'Low' 26/40
    '1.56' 'High' 22/44 'Low' 16/50
    '1.88' 'High' 32/34 'Low' 22/44
    '2.03' 'High' 26/40 'Low' 16/50
    '2.40' 'High' 36/30 'Low' 22/44
    '2.94' 'High' 32/34 'Low' 16/50
    '3.74' 'High' 36/30 'Low' 16/50};

count4=1;
Ratios=fopen('Ratios.csv','w');
fprintf('Stage 1  Stage 2   Spread   Ratio\n')
for count1=1:length(Ratio1)
    for count2=1:length(Ratio2)
        for count3=1:length(Spread)
            Conversion1=cell2mat(Ratio1(count1,2));
            Conversion2=cell2mat(Ratio2(count2,2));
            Conversion3=cell2mat(Spread(count3,5));
            Conversion4=cell2mat(Spread(count3,3));
            SolutionLow=Conversion1*Conversion2*Conversion3;
            SolutionHigh=Conversion1*Conversion2*Conversion4;
            count4=count4+1;
            fprintf(Ratios,'%s,%s,%s,%f,%f\n', Ratio1{count1, 1}, Ratio2{count2, 1}, Spread{count3, 1}, SolutionLow(1,1), SolutionHigh(1,1))
        end
    end
end
fclose(Ratios);