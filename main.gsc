init()
{
    level thread connected();
}

connected()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread spawned();
        player thread spawn_airdrop();
        player thread spawn_bot();

        player thread actionslotone();
        player thread actionslottwo();
		
		
		setDvar("jump_slowdownEnable", 0);
		setDvar("sv_cheats", 1);
    }
}

spawned()
{
    for(;;)
    {
        self waittill("spawned_player");
		self freezecontrols(false);
        self iprintln("^:Welcome To IW6X Cod Jumper");
    }
}

spawn_airdrop()
{
    for(;;)
    {
        self notifyonplayercommand("spawn_airdrop", "+actionslot 1");
        self waittill("spawn_airdrop");

        airdrop = spawn("script_model", self.origin + (0,0,-15));
        airdrop setmodel("carepackage_enemy_iw6");
        airdrop.angles = self.angles;
        airdrop clonebrushmodeltoscriptmodel(level.airdropcratecollision);
        wait .1;
    }
}

spawn_bot()
{
    for(;;)
    {
        if(self getstance() == "prone" && self adsbuttonpressed() && self meleebuttonpressed())
        {
            foreach(player in level.players)
            {
                if(isbot(player) == true)
                {
                    player setorigin(self.origin);
                    wait .2;
                    player freezecontrols(true);
                }
            }
        }

        wait .1;
    }
}

actionslotone()
{
    for(;;)
    {
        self notifyonplayercommand("left", "+actionslot 3");
        self waittill("left");

        if(self getstance() == "crouch")
        {
            self.neworigin = self.origin;
            self iprintln("Position ^2Saved");
        }

        wait .1;
    }
}

actionslottwo()
{
    for(;;)
    {
        self notifyonplayercommand("down", "+actionslot 2");
        self waittill("down");

        {
            if(isdefined(self.neworigin))
            {
                vector = (0,0,0);
                self setVelocity(vector);
                self setorigin(self.neworigin);
            }
            else
                self iprintln("save a position first");
        }

        wait .1;
    }
}

ufoToggle()
{
	for(;;)
	{
		self notifyonplayercommand("knife", "melee_zoom");
		
		{
			if(!self.ufomode || !isDefined(self.ufomode))
			{
			self thread penis();
			self.ufomode = true; 
			wait .05;
			self disableWeapons();
			self iPrintLn("UFO Mode ^2On");
			} 
			else 
		{ 
			self.ufomode = false; 
			self notify("NoclipOff");
			self unlink();
			self enableWeapons();
			self iPrintLn("UFO Mode ^1Off");
    }
}
    
penis()
{ 
    self endon("death"); 
    self endon("NoclipOff");
    if(isdefined(self.newufo)) self.newufo delete(); 
    self.newufo = spawn("script_origin", self.origin); 
    self.newufo.origin = self.origin; 
    self playerlinkto(self.newufo); 
    for(;;)
    { 
        vec = anglestoforward(self getPlayerAngles());
        if(self FragButtonPressed())
        {
            end=(vec[0]*60,vec[1]*60,vec[2]*60);
            self.newufo.origin=self.newufo.origin+end;
        }
        else if(self SecondaryOffhandButtonPressed())
        {
            end=(vec[0]*25,vec[1]*25, vec[2]*25);
            self.newufo.origin=self.newufo.origin+end;
        } 
        wait 0.05; 
    }
}