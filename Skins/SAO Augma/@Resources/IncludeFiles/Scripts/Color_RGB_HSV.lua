--[[
Name = Color_RGB_HSV.lua
Author = 雪月花
Version = 1.0
License = CC BY - NC - SA 4.0
Information = RGB与HSV模式的颜色代码转换
]]

-- 拆分颜色变量为三个单独的数字
function SeperateRGB(RGBStr)
	local _,_,StrR,StrG,StrB=string.find(RGBStr,"(.*),(.*),(.*)")
	local R,G,B=tonumber(StrR),tonumber(StrG),tonumber(StrB)
	return R,G,B
end

-- RGB颜色代码转HSV
function rgb2hsv(R,G,B)
	local H,S,V
	local Rr,Gg,Bb=R/255,G/255,B/255
	local Max=math.max(Rr,Gg,Bb)
	local Min=math.min(Rr,Gg,Bb)
	if Max==Min then H=0
	else
		if Rr==Max then
			H=(Gg-Bb)/(Max-Min)
		elseif Gg==Max then
			H=(Bb-Rr)/(Max-Min)+2
		elseif Bb==Max then
			H=(Rr-Gg)/(Max-Min)+4
		end
	end
	H=H*60
	if H<0 then H=H+360 end
	if H==360 then H=0 end
	if Max==0 then S=0
	else
		S=(Max-Min)/Max
	end
	V=Max
	return H,S,V
end

--HSV颜色代码转RGB
function hsv2rgb(H,S,V)
	if H<0 then H=H+360
	elseif H>360 then H=H-360
	end
	S=Clamp(S,0,1)
	V=Clamp(V,0,1)
	local R,G,B
	if S==0 then
		R=V
		G=V
		B=V
	else
		local F,P,Q,T,I
		I=math.floor(H/60)
		F=H/60-I
		P=V*(1-S)
		Q=V*(1-S*F)
		T=V*(1-S*(1-F))
		if I==0 or I==6 then
			R,G,B=V,T,P
		elseif I==1 then
			R,G,B=Q,V,P
		elseif I==2 then
			R,G,B=P,V,T
		elseif I==3 then
			R,G,B=P,Q,V
		elseif I==4 then
			R,G,B=T,P,V
		elseif I==5 then
			R,G,B=V,P,Q
		end
	end
	R=math.floor(R*255+0.5)
	G=math.floor(G*255+0.5)
	B=math.floor(B*255+0.5)
	return R,G,B
end

function Clamp(N,Min,Max)
	if N<Min then
		return Min
	elseif N>Max then
		return Max
	else
		return N
	end
end

