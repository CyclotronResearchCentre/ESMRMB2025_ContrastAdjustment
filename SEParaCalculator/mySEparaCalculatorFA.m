function [c,cupper,clower,cupperupper,cupperlower,upperTRmaxIndex, upperTEmaxIndex,myLowerContrastRange,myUpperContrastRange,TRindex,UpperRangecol,LowerRangecol] ...
= mySEparaCalculatorFA(FA, TR,TE,T1_1,T2_1,T1_2,T2_2,PD1,PD2,ratio, range)

[tr ,te] = meshgrid(TR, TE);

WT1_1 = 1 - (((1-cos(FA))*exp(-(tr - te/2)/T1_1)) - (cos(FA) * exp(-tr/T1_1)));
WT2_1 = exp(-te/T2_1);

signal1 = PD1* WT1_1 .* WT2_1;

WT1_2 = 1 - (((1-cos(FA))*exp(-(tr - te/2)/T1_2)) - (cos(FA) * exp(-tr/T1_2)));
WT2_2 = exp(-te/T2_2);

signal2 = PD2 * WT1_2 .* WT2_2;

c = (signal2-signal1);

figure;
for i=1:size(TR,2)
    hold on;
    plot(TE,c(:,i), 'color', 'k','LineWidth',4);
end

xlabel("TE [ms]",'fontsize', 28);
ylabel("contrast",'fontsize', 28);



c = c';

[TRnegIndex, TEnegIndex] = find(c<0);
[TRposIndex, TEposIndex] = find(c>0);


c = abs(c);



cupper = zeros(size(c,1),size(c,2));
clower = zeros(size(c,1),size(c,2));

if ~isempty(TEnegIndex)
    
    
[TRcrossIndex, TEcrossIndex] = find(c==min(c,[],2));

cupper = zeros(size(c,1),size(c,2));
clower = zeros(size(c,1),size(c,2));

for i=1:size(TR,2)
    cupper(TRcrossIndex(i),TEcrossIndex(i):end) = c(TRcrossIndex(i),TEcrossIndex(i):end);
    clower(TRcrossIndex(i),1:TEcrossIndex(i)-1) = c(TRcrossIndex(i),1:TEcrossIndex(i)-1);
end


figure;

[upperTRmaxIndex, upperTEmaxIndex] = find(cupper==max(cupper,[],2));

cupperupper = zeros(size(c,1),size(c,2));
cupperlower = zeros(size(c,1),size(c,2));

for i=1:size(TR,2)
    cupperupper(upperTRmaxIndex(i),upperTEmaxIndex(i):end) = cupper(upperTRmaxIndex(i),upperTEmaxIndex(i):end);
    cupperlower(upperTRmaxIndex(i),TEcrossIndex(i):upperTEmaxIndex(i)-1) = cupper(upperTRmaxIndex(i),TEcrossIndex(i):upperTEmaxIndex(i)-1);
end

myLowerContrastRange = zeros(size(TR,2),1);
myUpperContrastRange = zeros(size(TR,2),1);

for i=1:size(TR,2)
    
    if TE(upperTEmaxIndex(i))<max(TE)
        
        if max(cupperlower(i,cupperlower(i,:)~=0)) ~= 0
            
        myLowerContrastRange(i) = max(cupperlower(i,cupperlower(i,:)~=0)) - min(cupperlower(i,cupperlower(i,:)~=0));
        myUpperContrastRange(i) = max(cupperupper(i,cupperupper(i,:)~=0)) - min(cupperupper(i,cupperupper(i,:)~=0));
        
        
      if  min(cupperlower(i,cupperlower(i,:)~=0)) < min(cupperupper(i,cupperupper(i,:)~=0))
          
          [LowerRangecol] = find( (cupperlower(i,cupperlower(i,:)~=0) >= (((ratio-range)*myLowerContrastRange(i)) + min(cupperlower(i,cupperlower(i,:)~=0))) ...
        &  (cupperlower(i,cupperlower(i,:)~=0) <= (((ratio+range)*myLowerContrastRange(i)) + min(cupperlower(i,cupperlower(i,:)~=0))))));
    
         [UpperRangecol] = find( (cupperupper(i,cupperupper(i,:)~=0) >= (((ratio-range)*myLowerContrastRange(i)) + min(cupperlower(i,cupperlower(i,:)~=0)))) ...
            &  (cupperupper(i,cupperupper(i,:)~=0) <= (((ratio+range)*myLowerContrastRange(i)) + min(cupperlower(i,cupperlower(i,:)~=0)))));
    
      else 
          [LowerRangecol] = find( (cupperlower(i,cupperlower(i,:)~=0) >= (((ratio-range)*myUpperContrastRange(i)) + min(cupperupper(i,cupperupper(i,:)~=0)))) ...
        &  (cupperlower(i,cupperlower(i,:)~=0) <= (((ratio+range)*myUpperContrastRange(i)) + min(cupperupper(i,cupperupper(i,:)~=0)))));
    
         [UpperRangecol] = find((cupperupper(i,cupperupper(i,:)~=0) >= (((ratio-range)*myUpperContrastRange(i)) + min(cupperupper(i,cupperupper(i,:)~=0)))) ...
            &  (cupperupper(i,cupperupper(i,:)~=0) <= ((ratio+range)*myUpperContrastRange(i) + min(cupperupper(i,cupperupper(i,:)~=0)))));
      end
      
      

        TRindex = zeros(1,size(TE(LowerRangecol),2));
        TRindex(:) = TR(upperTRmaxIndex(i));

        hold on
        
        if ~isempty(TE(LowerRangecol))
         stem(TE(LowerRangecol), TRindex,'k','LineWidth',6);
        end

        TRindex = zeros(1,size(TE(UpperRangecol),2));
        TRindex(:) = TR(upperTRmaxIndex(i));
        
        hold on
        if ~isempty(TE(UpperRangecol))
        stem(TE(UpperRangecol+upperTEmaxIndex(i)-2), TRindex,'r','LineWidth',6);
        end

        end
        
    else
        
        myContrastRange(i) = max(cupper(i,cupper(i,:)~=0)) - min(cupper(i,cupper(i,:)~=0));
        
        [col] = find( (cupper(i,cupper(i,:)~=0) >= (((ratio-range)*myContrastRange(i)) + min(cupper(i,cupper(i,:)~=0)))) ...
        &  (cupper(i,cupper(i,:)~=0) <= (((ratio+range)*myContrastRange(i)) + min(cupper(i,cupper(i,:)~=0)))) );

        TRindex = zeros(1,size(TE(col),2));
        TRindex(:) = TR(upperTRmaxIndex(i));

        hold on

        stem(TE(col), TRindex,'b','LineWidth',6);
        
    end
    
end

myLowerContrastRange = zeros(size(TR,2),1);

for i=1:size(TR,2)
    
    if max(clower(i,clower(i,:)~=0)) ~= 0

        myLowerContrastRange(i,1) = max(clower(i,clower(i,:)~=0)-min(clower(i,clower(i,:)~=0)));

          [LowerRangecol] = find( clower(i,clower(i,:)~=0) >= (((ratio-range)*myLowerContrastRange(i,1))+ min(clower(i,clower(i,:)~=0))));
          
        TRindex = zeros(1,size(TE(LowerRangecol),2));
        TRindex(:) = TR(TRcrossIndex(i));

        hold on

        stem(TE(LowerRangecol), TRindex,'b','LineWidth',6);
    end
        
end
    
elseif isempty(TEnegIndex)

[TRmaxIndex, TEmaxIndex] = find(c==max(c,[],2));

myLowerContrastRange = zeros(size(TR,2),1);
myUpperContrastRange = zeros(size(TR,2),1);

for i=1:size(TR,2)
        cupper(TRmaxIndex(i),TEmaxIndex(i):end) = c(TRmaxIndex(i),TEmaxIndex(i):end);
        clower(TRmaxIndex(i),1:TEmaxIndex(i)-1) = c(TRmaxIndex(i),1:TEmaxIndex(i)-1);     
end

figure;

for i=1:size(TR,2)
    
    if TE(TEmaxIndex(i))>min(TE)
        
        myLowerContrastRange(i) = max(clower(i,clower(i,:)~=0)) - min(clower(i,clower(i,:)~=0));
        myUpperContrastRange(i) = max(cupper(i,cupper(i,:)~=0)) - min(cupper(i,cupper(i,:)~=0));
        
        
      if  min(clower(i,clower(i,:)~=0)) < min(cupper(i,cupper(i,:)~=0))
          
          [LowerRangecol] = find( (clower(i,clower(i,:)~=0) >= (((ratio-range)*myLowerContrastRange(i)) + min(clower(i,clower(i,:)~=0))) ...
        &  (clower(i,clower(i,:)~=0) <= (((ratio+range)*myLowerContrastRange(i)) + min(clower(i,clower(i,:)~=0))))));
    
         [UpperRangecol] = find( (cupper(i,cupper(i,:)~=0) >= (((ratio-range)*myLowerContrastRange(i)) + min(clower(i,clower(i,:)~=0)))) ...
            &  (cupper(i,cupper(i,:)~=0) <= (((ratio+range)*myLowerContrastRange(i)) + min(clower(i,clower(i,:)~=0)))));
    
      else 
          [LowerRangecol] = find( (clower(i,clower(i,:)~=0) >= (((ratio-range)*myUpperContrastRange(i)) + min(cupper(i,cupper(i,:)~=0)))) ...
        &  (clower(i,clower(i,:)~=0) <= (((ratio+range)*myUpperContrastRange(i)) + min(cupper(i,cupper(i,:)~=0)))));
    
         [UpperRangecol] = find((cupper(i,cupper(i,:)~=0) >= (((ratio-range)*myUpperContrastRange(i)) + min(cupper(i,cupper(i,:)~=0)))) ...
            &  (cupper(i,cupper(i,:)~=0) <= ((ratio+range)*myUpperContrastRange(i) + min(cupper(i,cupper(i,:)~=0)))));
      end
      
      

        TRindex = zeros(1,size(TE(LowerRangecol),2));
        TRindex(:) = TR(TRmaxIndex(i));

        hold on
        
        if ~isempty(TE(LowerRangecol))
         stem(TE(LowerRangecol), TRindex,'k','LineWidth',6);
        end

        TRindex = zeros(1,size(TE(UpperRangecol),2));
        TRindex(:) = TR(TRmaxIndex(i));

        hold on
        if ~isempty(TE(UpperRangecol+TEmaxIndex(i)-1))
        stem(TE(UpperRangecol+TEmaxIndex(i)-1), TRindex,'r','LineWidth',6);
        end
        
    else
        
        myContrastRange(i) = max(c(i,c(i,:)~=0)) - min(c(i,c(i,:)~=0));
        
        [col] = find( (c(i,c(i,:)~=0) >= (((ratio-range)*myContrastRange(i)) + min(c(i,c(i,:)~=0)))) ...
        &  (c(i,c(i,:)~=0) <= (((ratio+range)*myContrastRange(i)) + min(c(i,c(i,:)~=0)))) );

        TRindex = zeros(1,size(TE(col),2));
        TRindex(:) = TR(i);

        hold on

        stem(TE(col), TRindex,'b','LineWidth',6);
        
    end
    
end

xlabel('TE [ms]','FontSize',38);
ylabel('TR [ms]','FontSize',38);

% myStringTR = sprintf('TR = %0.0f-%0.0f [ms] ',min(TR),max(TR));
myStringTR = sprintf('TR = %0.0f [ms] ',TR);
myStringTE = sprintf('TE = %0.0f-%0.0f [ms] ',min(TE),max(TE));
myStringContrastLevel = sprintf('Contrast = %0.0f ± %0.0f %% of its maximum', ratio*100,range*100);
title({myStringTR;myStringTE; myStringContrastLevel},'FontSize',38);

xlim([min(TE) max(TE)])




end
     



