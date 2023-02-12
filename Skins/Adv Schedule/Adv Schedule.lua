function Initialize()
	bSO='!SetOption'
	bWKV='!WriteKeyValue'
	bRF='!Refresh'
	bSM='!ShowMeter'
	bHM='!HideMeter'
	bUMT='!UpdateMeter'
	bMM='!MoveMeter'
	bCM='!CommandMeasure'
	msWN=SKIN:GetMeasure('MeasureWeekNum')
	msT=SKIN:GetMeasure('MeasureTime')
	sFC1S=string.match(SKIN:GetVariable('FontColor1'),'(%d*,%d*,%d*)%,?%d*')
	sFC1A=string.match(SKIN:GetVariable('FontColor1'),'%d*,%d*,%d*%,?(%d*)')
	if sFC1A=='' then sFC1A='255' end
	sFC2S=string.match(SKIN:GetVariable('FontColor2'),'(%d*,%d*,%d*)%,?%d*')
	sFC2A=string.match(SKIN:GetVariable('FontColor2'),'%d*,%d*,%d*%,?(%d*)')
	if sFC2A=='' then sFC2A='255' end
	sSC1S=string.match(SKIN:GetVariable('SolidColor1'),'(%d*,%d*,%d*)%,?%d*')
	sSC1A=string.match(SKIN:GetVariable('SolidColor1'),'%d*,%d*,%d*%,?(%d*)')
	if sSC1A=='' then sSC1A='255' end
	sSC2S=string.match(SKIN:GetVariable('SolidColor2'),'(%d*,%d*,%d*)%,?%d*')
	sSC2A=string.match(SKIN:GetVariable('SolidColor2'),'%d*,%d*,%d*%,?(%d*)')
	if sSC2A=='' then sSC2A='255' end
	sSC3S=string.match(SKIN:GetVariable('SolidColor3'),'(%d*,%d*,%d*)%,?%d*')
	sSC3A=string.match(SKIN:GetVariable('SolidColor3'),'%d*,%d*,%d*%,?(%d*)')
	if sSC3A=='' then sSC3A='255' end
	iSW=tonumber(SKIN:GetVariable('SectionWidth'))
	iBW=tonumber(SKIN:GetVariable('BlockWidth'))
	iBH=tonumber(SKIN:GetVariable('BlockHeight'))
	iBI=tonumber(SKIN:GetVariable('BlockInterval'))
	iCP=tonumber(SKIN:GetVariable('Center'))
	iBWI=iBW+iBI
	iBHI=iBH+iBI
	sWN={}
	sSP={}
	sSN={}
	sSS={}
	sSE={}
	iSS={}
	iSE={}
	sCP={}
	sCN={}
	iCW={}
	iCS={}
	iCE={}
	for i=1,7 do
		sWN[i]=tostring(SKIN:GetVariable('Weekday'..i))
		SKIN:Bang(bSO,'MeterW'..i,'W',iBW)
		SKIN:Bang(bSO,'MeterW'..i,'Text',sWN[i])
	end
	iSN=0
	while (type(SKIN:GetVariable('Section'..iSN+1))~='nil') do
		iSN=iSN+1
		sSP[iSN]=tostring(SKIN:GetVariable('Section'..iSN))
		sSN[iSN]=string.match(sSP[iSN],'(.*)%.%.%d*:%d*%.%.%d*:%d*')
		sSS[iSN]=string.match(sSP[iSN],'.*%.%.(%d*:%d*)%.%.%d*:%d*')
		sSE[iSN]=string.match(sSP[iSN],'.*%.%.%d*:%d*%.%.(%d*:%d*)')
		iSS[iSN]=tonumber(string.match(sSS[iSN],'(%d*):%d*')*60+string.match(sSS[iSN],'%d*:(%d*)'))
		iSE[iSN]=tonumber(string.match(sSE[iSN],'(%d*):%d*')*60+string.match(sSE[iSN],'%d*:(%d*)'))
		SKIN:Bang(bSO,'MeterS'..iSN,'Text',sSN[iSN])
	end
	SKIN:Bang(bSO,'MeterT','H',iSN*iBHI-iBI)
	iCN=0
	iWM=0
	while (type(SKIN:GetVariable('Class'..iCN+1))~='nil') do
		iCN=iCN+1
		sCP[iCN]=tostring(SKIN:GetVariable('Class'..iCN))
		sCN[iCN]=string.match(sCP[iCN],'(.*)%.%.%d*%.%.%d*%.%.%d*')
		iCW[iCN]=tonumber(string.match(sCP[iCN],'.*%.%.(%d*)%.%.%d*%.%.%d*'))
		if iCW[iCN]>iWM then iWM=iCW[iCN] end
		iCS[iCN]=tonumber(string.match(sCP[iCN],'.*%.%.%d*%.%.(%d*)%.%.%d*'))
		iCE[iCN]=tonumber(string.match(sCP[iCN],'.*%.%.%d*%.%.%d*%.%.(%d*)'))
		SKIN:Bang(bSO,'MeterC'..iCN,'Text',sCN[iCN])
	end
	sBP=tostring(SKIN:GetVariable('CURRENTPATH'))..'Blocks.inc'
	fB=io.open(sBP,'r')
	sB=fB:read('*a')
	fB:close()
	iBR=0
	iBL=(iSN+iCN*2)*44
	for i=1,iSN do
		iBS=string.find(sB,'[^\r%;]-%[MeterS'..i..'%]\nMeter=STRING\nMeterStyle=StyleText')
		iBL=iBL+math.floor((math.log10(i)))
		if type(iBS)=='nil' then iBR=1 end
	end
	for i=1,iCN do
		iBB=string.find(sB,'[^\r%;]-%[MeterB'..i..'%]\nMeter=IMAGE\nMeterStyle=StyleBlock')
		iBC=string.find(sB,'[^\r%;]-%[MeterC'..i..'%]\nMeter=STRING\nMeterStyle=StyleItem')
		iBL=iBL+math.floor((math.log10(i)))*2
		if (type(iBB)=='nil')or(type(iBC)=='nil') then iBR=1 end
	end
	if string.len(sB)~=iBL then iBR=1 end
	if iBR>0 then
		fB=io.open(sBP,'w')
		fB:close()
		for i=1,iSN do
			SKIN:Bang(bWKV,'MeterS'..i,'Meter','STRING',sBP)
			SKIN:Bang(bWKV,'MeterS'..i,'MeterStyle','StyleText',sBP)
		end
		for i=1,iCN do
			SKIN:Bang(bWKV,'MeterB'..i,'Meter','IMAGE',sBP)
			SKIN:Bang(bWKV,'MeterB'..i,'MeterStyle','StyleBlock',sBP)
			SKIN:Bang(bWKV,'MeterC'..i,'Meter','STRING',sBP)
			SKIN:Bang(bWKV,'MeterC'..i,'MeterStyle','StyleItem',sBP)
		end
		SKIN:Bang(bRF)
	end
	iSH=iCP*(iWM-1)*iBWI
	if iWM<7 then
		for i=iWM+1,7 do
			SKIN:Bang(bHM,'MeterW'..i)
		end
	end
	iMM=8
	iUF=tonumber(SKIN:GetVariable('Unfold'))
	if iUF==2 then
		iM=0
		SKIN:Bang(bMM,iSH,2*iBHI,'MeterT')
		SKIN:Bang(bSO,'MeterT','W',iSW+iBWI)
		SKIN:Bang(bSO,'MeterT','MouseOverAction',bCM..' MeasureScript iT=iMM')
		SKIN:Bang(bSO,'MeterT','MouseLeaveAction',bCM..' MeasureScript iT=0')
	else
		iM=iUF*iMM
		SKIN:Bang(bMM,iSH*(1-iM/iMM),2*iBHI,'MeterT')
		SKIN:Bang(bSO,'MeterT','W',iSW+(iUF*(iWM-1)+1)*iBWI)
		SKIN:Bang(bSO,'MeterT','LeftMouseUpAction',bCM..' MeasureScript M()')
	end
	iT=iM
	iW=0
	iC=0
end

function Update()
	iWN=msWN:GetValue()
	if iWN==0 then iWN=7 end
	sT=msT:GetStringValue()
	if iBR==0 then
		if iM==iT then
			if (iW~=iWN)or(iC~=tonumber(string.match(sT,'(%d*):%d*')*60+string.match(sT,'%d*:(%d*)'))) then
				iW=iWN
				iC=tonumber(string.match(sT,'(%d*):%d*')*60+string.match(sT,'%d*:(%d*)'))
				if iWN>iWM then
					iS=1
				else
					iS=iW
				end
				U()
			end
		else
			iM=iM+math.abs(iT-iM)/(iT-iM)
			U()
			E()
		end
	end
end

function M()
	iT=iMM-iM
	SKIN:Bang(bHM,'MeterT')
end

function U()
	SKIN:Bang(bMM,(iSW+iBWI)/2+iSH*(1-iM/iMM),iBH/2,'MeterTime')
	SKIN:Bang(bMM,iSW/2+iSH*(1-iM/iMM),iBHI+iBH/2,'MeterConfig')
	for i=1,iWM do
		SKIN:Bang(bMM,iBWI+(i-1)*iBWI*iM/iMM+iSH*(1-iM/iMM),iBH/2+iBHI,'MeterW'..i)
		if i==iS then
			SKIN:Bang(bSO,'MeterW'..i,'SolidColor','#SolidColor1#')
			SKIN:Bang(bSO,'MeterW'..i,'FontColor','#FontColor1#')
		else
			SKIN:Bang(bSO,'MeterW'..i,'SolidColor',sSC1S..','..sSC1A*iM/iMM)
			SKIN:Bang(bSO,'MeterW'..i,'FontColor',sFC1S..','..sFC1A*iM/iMM)
		end
		SKIN:Bang(bUMT,'MeterW'..i)
	end
	for i=1,iSN do
		SKIN:Bang(bMM,iSW/2+iSH*(1-iM/iMM),iBH/2+(i+1)*iBHI,'MeterS'..i)
	end
	SKIN:Bang(bHM,'MeterB')
	for i=1,iCN do
		SKIN:Bang(bMM,iSW+iBI+iBW/2+(iCW[i]-1)*iBWI*iM/iMM+iSH*(1-iM/iMM),(iCS[i]+1)*iBHI+(iBH+(iCE[i]-iCS[i])*iBHI)/2,'MeterC'..i)
		SKIN:Bang(bMM,iSW+iBI+(iCW[i]-1)*iBWI*iM/iMM+iSH*(1-iM/iMM),(iCS[i]+1)*iBHI,'MeterB'..i)
		SKIN:Bang(bSO,'MeterB'..i,'H',iBH+(iCE[i]-iCS[i])*iBHI)
		if iCW[i]~=iS then
			SKIN:Bang(bSO,'MeterC'..i,'FontColor',sFC2S..','..sFC2A*iM/iMM)
		else
			SKIN:Bang(bSO,'MeterC'..i,'FontColor','#FontColor2#')
		end
		SKIN:Bang(bUMT,'MeterC'..i)
		if iS==iW then
			if iCW[i]~=iS then
				if iCW[i]<iS then
					SKIN:Bang(bSO,'MeterB'..i,'SolidColor',sSC3S..','..sSC3A*iM/iMM)
				else
					SKIN:Bang(bSO,'MeterB'..i,'SolidColor',sSC2S..','..sSC2A*iM/iMM)
				end
			else
				if iSE[iCE[i]]<=iC then
					SKIN:Bang(bSO,'MeterB'..i,'SolidColor','#SolidColor3#')
				elseif iSS[iCS[i]]>iC then
					SKIN:Bang(bSO,'MeterB'..i,'SolidColor','#SolidColor2#')
				else
					iP=math.floor((iBH+(iCE[i]-iCS[i])*iBHI)*((iC-iSS[iCS[i]])/(iSE[iCE[i]]-iSS[iCS[i]])))
					SKIN:Bang(bSO,'MeterB'..i,'SolidColor','#SolidColor3#')
					SKIN:Bang(bSO,'MeterB'..i,'H',iP)
					SKIN:Bang(bSM,'MeterB')
					SKIN:Bang(bMM,iSW+iBI+(iCW[i]-1)*iBWI*iM/iMM+iSH*(1-iM/iMM),(iCS[i]+1)*iBHI+iP,'MeterB')
					SKIN:Bang(bSO,'MeterB','H',iBH+(iCE[i]-iCS[i])*iBHI-iP)
					SKIN:Bang(bUMT,'MeterB')
				end
			end
		else
			if iCW[i]~=iS then
				SKIN:Bang(bSO,'MeterB'..i,'SolidColor',sSC2S..','..sSC2A*iM/iMM)
			else
				SKIN:Bang(bSO,'MeterB'..i,'SolidColor','#SolidColor2#')
			end
		end
		SKIN:Bang(bUMT,'MeterB'..i)
	end
end

function E()
	if (iM==iT)and(iUF<2) then
		SKIN:Bang(bSM,'MeterT')
		if iM==0 then
			SKIN:Bang(bWKV,'Variables','Unfold',0,'#CURRENTPATH#Variables.inc')
			SKIN:Bang(bMM,iSH,2*iBHI,'MeterT')
			SKIN:Bang(bSO,'MeterT','W',iSW+iBWI)
		else
			SKIN:Bang(bWKV,'Variables','Unfold',1,'#CURRENTPATH#Variables.inc')
			SKIN:Bang(bMM,0,2*iBHI,'MeterT')
			SKIN:Bang(bSO,'MeterT','W',iSW+iWM*iBWI)
		end
		SKIN:Bang(bUMT,'MeterT')
	end
end