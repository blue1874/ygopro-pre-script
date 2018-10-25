--掃射特攻
--Blitzkrieg Bombardment
--Scripted by Logical Nonsense and edo9300 and mercury233
function c100411038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetLabel(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c100411038.descost)
	e2:SetTarget(c100411038.destg)
	e2:SetOperation(c100411038.desop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c100411038.damcon)
	e3:SetCost(c100411038.damcost)
	e3:SetTarget(c100411038.damtg)
	e3:SetOperation(c100411038.damop)
	c:RegisterEffect(e3)
end
function c100411038.rmfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c100411038.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c100411038.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
				and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		else return false end
	end
	local rt=Duel.GetTargetCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local ct=0
	local min=1
	while ct<rt do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
		local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,min,1,nil,tp,1,REASON_COST)
		sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
		ct=ct+1
		min=0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100411038.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c100411038.cfilter(c,e,tp)
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
		and c:IsPreviousPosition(POS_FACEUP) and c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c100411038.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100411038.cfilter,1,nil,e,tp)
end
function c100411038.damfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost() and c:GetRank()>0
end
function c100411038.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c100411038.damfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100411038.damfilter,tp,LOCATION_GRAVE,0,1,1,c)
	e:SetLabel(g:GetFirst():GetRank())
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100411038.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel()*200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel()*200)
end
function c100411038.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
