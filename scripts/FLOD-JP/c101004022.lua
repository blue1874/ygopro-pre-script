--エレメントセイバー・マロー
--Elementsaber Malo
function c101004022.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004022,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101004022.sgcost)
	e1:SetTarget(c101004022.sgtg)
	e1:SetOperation(c101004022.sgop)
	c:RegisterEffect(e1)	
	--att change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004022,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101004022.atttg)
	e2:SetOperation(c101004022.attop)
	c:RegisterEffect(e2)
end
function c101004022.costfilter(c)
	return c:IsSetCode(0x400d) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c101004022.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101004022.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101004022.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c101004022.filter(c)
	return c:IsSetCode(0x400d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101004022.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101004022.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101004022.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101004022.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101004022.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local aat=Duel.AnnounceAttribute(tp,1,0xff-e:GetHandler():GetAttribute())
	e:SetLabel(aat)
end
function c101004022.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
