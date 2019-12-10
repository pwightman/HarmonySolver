document.getElementById("staff").innerHTML = "";

var vf = new Vex.Flow.Factory({
  renderer: { elementId: "staff", width: 620, height: 500 }
});

var score = vf.EasyScore();

var json = %json%;

var x = 20;
var y = 80;

function makeSystem(width) {
  var system = vf.System({ x: x, y: y, width: width, spaceBetweenStaves: 10 });
  x += width;
  return system;
}

for (let i = 0; i < json.soprano.length; i++) {
  var system = makeSystem(300);

  var stave = system
    .addStave({
      voices: [
        score.voice(score.notes(json.soprano[i], { stem: "up" })),
        score.voice(score.notes(json.alto[i], { stem: "down" }))
      ]
    })

  if (i === 0) {
    stave.addClef("treble")
    stave.addTimeSignature("4/4");
  }

  stave = system
    .addStave({
      voices: [
        score.voice(score.notes(json.tenor[i], { stem: "up", clef: "bass" })),
        score.voice(score.notes(json.bass[i], { stem: "down", clef: "bass" }))
      ]
    })

  if (i === 0) {
    stave.addClef("bass")
    stave.addTimeSignature("4/4");
    system.addConnector()
  }
}

vf.draw();

("hi");
