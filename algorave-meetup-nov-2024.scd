

//supercollider tutorial:



rrand(0,127);


(

rrand(0,127);



)


[40,405,60].choose;

(
Ndef(\a,{SinOsc.ar(60, mul:0.1)});


)


(
Ndef(\a,{SinOsc.ar([40,405,60].choose;, mul:0.1)});

)

(
Ndef(\a,{SinOsc.ar(rrand(60,300);, mul:0.1)});

)


Ndef(\a).play;
Ndef(\a).stop;

//clears all the stored ndefs
Ndef.clear;


//compare the control rate kr


(
Ndef(\a,{SinOsc.kr(SinOsc.kr(1).range(50,160), mul:0.2)});
)


(
Ndef(\a,{SinOsc.ar(SinOsc.ar(1).range(50,160), mul:0.2)}
);
)


Ndef(\a, {WhiteNoise.ar()});




b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

~a1=Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
~a1.bufnum;

var ai;

Ndef(\a, {PlayBuf.ar(b.numChannels, b,loop:1)*0.16});
//vs
Ndef(\a, {PlayBuf.ar(~a1.numChannels, ~a1.bufnum,loop:1)*0.16});


Ndef(\a, {PlayBuf.ar(b.numChannels, b,rate:LFNoise2.kr(10.1).range(-10.2,0.3),loop:1)*0.16});
//vs
~b1=Ndef(\a, {PlayBuf.ar(b.numChannels, b,rate:LFNoise2.kr(10.1).range(-10.2,0.3),loop:1)*0.16});


Ndef(\a).play;
Ndef(\a).stop;

~b1.play;
~b1.stop;



Ndef(\a).filter(1,{arg in; LPF.ar(in, 1500) });


// by incrementing the first value after the filter we can keep on adding effects to our effect chain
Ndef(\a).filter(1,{arg in; JPverb.ar(in) });

Ndef(\a).filter(2,{arg in; JPverb.ar(in) });

Ndef(\a).filter(3,{arg in; JPverb.ar(in) });

Ndef(\a).filter(4,{arg in; JPverb.ar(in) });


////////////////////////////////////////////


//vst example


VSTPlugin.search;
// or if your vst's are in a spesific folder
VSTPlugin.search(s,"D:/tee/VST" );


// ------------

(
Ndef(\test, \vst -> { VSTPlugin.ar(nil, 2) }).play;

~fx = VSTPluginNodeProxyController(Ndef(\test)).open("Dexed.vst3", editor: true, );
)

~fx.editor; // open the VST plugin editor
~fx.gui;

// you can save your presets my this syntax

~fx.savePreset("dx7-01");
~fx.loadPreset("dx7-01");



(
Pdef(\auto, Pbind(
    \type, \vst_midi,
    \vst, ~fx, // VSTPluginNodeProxyController
	\scale, Scale.minor,
	\degree, Pseq([[0,2,5]],inf)+Pn(Pseries(0,1,16),inf)-7,
	\dur, 0.3,
	\legato, Pexprand(0.7, 1.5, inf),
    \amp, Pexprand(0.8, 1.0, inf)
)).play;
);



Pdef(\auto).stop;
Pdef(\auto).play;











































(
Ndef(\a, {
	WhiteNoise.ar(0.02);


}
);

Ndef(\a).play(0,2);
































// custom events

(
Event.addEventType(\mnotectl, {
	currentEnvironment.copy.put(\type, \vst_midi).put(\vst_midi, \noteOn).play;
	currentEnvironment.copy.put(\type, \vst_set).put(\vst_set, \params).play;
});
)



(
Event.addEventType(\mnotectl, {
	currentEnvironment.copy.put(\type, \midi).put(\midicmd, \noteOn).play;
	currentEnvironment.copy.put(\type, \midi).put(\midicmd, \control).play;
});
)



VSTPlugin.search;

// ------------
// a) Filter white noise through a VST plugin
(
Ndef(\test, \vst -> { VSTPlugin.ar(nil, 2) }).play;

~fx = VSTPluginNodeProxyController(Ndef(\test)).open("Dexed.vst3", editor: true, );
)

~fx.editor; // open the VST plugin editor
~fx.gui;
~fx.savePreset("dx7-01");
~fx.loadPreset("dx7-01");


~fx.savePreset("dx7-28-10-01");
~fx.loadPreset("dx7-28-10-01");


~fx.savePreset("dx7-28-10-02");

// automate parameters with a Pbind of type \vst_set
(
Pdef(\auto, Pbind(
    \type, \mnotectl,
    \vst, ~fx, // VSTPluginNodeProxyController
	\scale, Scale.minor,
	\degree, Pseq([[0,2,5]],inf)+Pn(Pseries(0,1,16),inf)-7,
	\dur, 0.3,
	\params, [04, 05,07],
	04, Pwhite(0.00, 1.0),
	05, Pwhite(0.00,1.0),
	07, Pn(Pseries(0.0, 0.01, 100),inf),


    \legato, Pexprand(0.7, 1.5, inf),
    \amp, Pexprand(0.8, 1.0, inf)
)).play;
);



Pdef(\auto).stop;
Pdef(\auto).play;


(
Ndef(\test).filter(2,{|in, fbgrainsize2 = 0.05, fbgrainrand2 = 0.8, fbGain2 = 0.1, winsize2=0.25, pitch2=0.75, pd2=0.01, td2=0.001, numchans=1|
var bufLength = 1.0;
var localbuf1 = LocalBuf(bufLength * SampleRate.ir, 1).clear;
var localbuf2 = LocalBuf(bufLength * SampleRate.ir, 1).clear;
var warp;
var warp2;
var warp1 = Warp1.ar(1,	localbuf1,
				LFSaw.ar(1/bufLength).linlin(-1.0,1.0,0.0, 1.0),
				Drand([ 2, - 2 ], inf),
				fbgrainsize2.linlin(0.0, 1.0, 0.0, 2.0),
				-1,
				2,
				fbgrainrand2.linlin(0.0, 1.0, 0.2, 1.0),
				4
			);

			// record w/ feedback
//	var warp=LPF.ar(in);
RecordBuf.ar(tanh(in[0] + HPF.ar(tanh(warp1 * fbGain2), 30)), localbuf1);
warp2 = Warp1.ar(
				1,
				localbuf2,
				LFSaw.ar(1/bufLength).linlin(-1.0,1.0,0.0, 1.0),
				Drand([ 2, - 2 ], inf),
				fbgrainsize2.linlin(0.0, 1.0, 0.0, 2.0),
				-1,
				2,
				fbgrainrand2.linlin(0.0, 1.0, 0.2, 1.0),
				4
			);


	RecordBuf.ar(tanh(in[1] + HPF.ar(tanh(warp2 * fbGain2), 30)), localbuf2);





warp=Balance2.ar(warp1, warp2);
			warp = warp.tanh;
			warp = HPF.ar(warp * 0.5, 80);
			warp.sanitize;
			/*warp=PitchShift.ar(
					warp,
					windowSize: {rrand(0.95,1.0)} * winsize2,
					pitchRatio: {rrand(0.95,1.0)} * pitch2.linexp(0.0,1.0,0.001,4.0),
					pitchDispersion:{rrand(0.95,1.0)} *  pd2,
					timeDispersion:{rrand(0.95,1.0)} * td2
				)*/


		};
);
)

Ndef(\test).fadeTime=3;

Ndef(\test).set(\wet2,0.0);
