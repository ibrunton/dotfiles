/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]            = "-*-terminus-medium-r-*-*-16-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#333333";
static const char normbgcolor[]     = "#052111";
static const char normfgcolor[]     = "#aaaaaa";
static const char selbordercolor[]  = "#14915f";
static const char selbgcolor[]      = "#14915f";
static const char selfgcolor[]      = "#ffffff";
/*#define NUMCOLORS 3*/
/*static const char colors[NUMCOLORS][ColLast][8] = {
	[> border	  fg		 bg <]
	{ "#333333", "#aaaaaa", "#051121" }, [> normal <]
	{ "#14915f", "#000000", "#14915f" }, [> selected <]
	{ "#ff0000", "#000000", "#cecece" }, [> urgent <] 
};*/

static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappx	    = 4;	/* gap pixel width */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */
static const Bool focusonclick	    = True;	/* change focus only on click */

static const Rule rules[] = {
	/* class		instance    title       tags mask     isfloating   monitor */
	{ "Gimp",		NULL,       NULL,       1 << 5,		True,		-1 },
	{ "Firefox",	NULL,       NULL,       1 << 1,		False,		-1 },
	{ "Okular",		NULL,       NULL,       1 << 4,		True,		-1 },
	{ "Qwit",		NULL,		NULL,		1 << 1,		False,		-1 },
};

/* layout(s) */
static const int nmaster      = 1; /* number of clients in master area */
static const float mfact      = 0.5; /* factor of master area size [0.05..0.95] */
static const Bool resizehints = False; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     gaps		arrange function */
	{ "[T]",      True,		tile },    /* first entry is default */
	{ "[F]",      False,	NULL },    /* no layout function means floating behavior */
	{ "[M]",      False,	monocle },
};

/* tagging */
/* static const char *tags[] = { "term", "www", "xdr", "dev", "doc", "etc" }; */
static const Tag tags[] = {
  /* name	layout			mfact	monitor */
  { "term",	&layouts[0],	-1,		-1 },
  { "www",	&layouts[0],	0.75,	-1 },
  { "xdr",	&layouts[1],	-1,		-1 },
  { "dev",	&layouts[0],	0.55,	-1 },
  { "doc",	&layouts[1],	-1,		-1 },
  { "etc",	&layouts[1],	-1,		-1 },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[]	   = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *mymenucmd[]	   = { "/home/ian/bin/dmenu_custom.bash", NULL };
static const char *termcmd[]	   = { "urxvt", NULL };
static const char *emacscmd[]	   = { "/home/ian/bin/emet", NULL };
static const char *volmcmd[]	   = { "amixer", "-q", "sset", "Master", "toggle", NULL };
static const char *voldcmd[]       = { "amixer", "-q", "sset", "Master", "1-", "unmute", NULL };
static const char *volucmd[]       = { "amixer", "-q", "sset", "Master", "1+", "unmute", NULL };
static const char *slrhcmd[]	   = { "/home/ian/bin/slrh.sh", NULL };
/* static const char *mpdvoldcmd[]    = { "ncmpcpp", "volume", "-2", NULL }; */
/* static const char *mpdvolucmd[]    = { "ncmpcpp", "volume", "+2", NULL }; */
/* static const char *mpdtogglecmd[]  = { "ncmpcpp", "toggle", NULL }; */
/* static const char *mpdstopcmd[]    = { "ncmpcpp", "stop", NULL }; */
/* static const char *mpdprevcmd[]    = { "ncmpcpp", "prev", NULL }; */
/* static const char *mpdnextcmd[]    = { "ncmpcpp", "next", NULL }; */

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_w,      spawn,          {.v = mymenucmd } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = emacscmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,				XK_j,	   pushdown,	   {0} },
	{ MODKEY|ShiftMask,				XK_k,	   pushup,		   {0} },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	/*{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },*/
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	/*{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },*/
	/*{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },*/
	/*{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },*/
	/*{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },*/
	{ MODKEY,                       XK_F10,    spawn,          {.v = voldcmd } },
	{ MODKEY,                       XK_F11,    spawn,          {.v = volmcmd } },
	{ MODKEY,                       XK_F12,    spawn,          {.v = volucmd } },
	{ MODKEY|ShiftMask,             XK_Escape, spawn,          {.v = slrhcmd } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

