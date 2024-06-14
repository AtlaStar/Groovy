# Groovy is an attempt at making something sorely lacking in the current version of Gamemaker Studio; a simple and effective way of creating physics geometry.

## What does this mean?
It means a tool that allows you to draw as you would in any art creation program, and turn those brush strokes into an interchange format that becomes physics objects in Gamemaker Studio 2.

## What is it's current release state?
Currently Groovy is in a _very_ early state as the editor implementations are starting to exist, but this project currently exists mostly as a play space with what has been implemented.

## What is implemented so far?
Implemented features include DeCastlejau's alg to generate bezier's, support for open and closed polybeziers, a single brush tool in progress that generates a hollow closed star-like shape that is created as a polybezier. Also generates the fixtures for these physics objects so that they
can interact in a physics world. early UI composition in progress.

## What is left?
Honestly, a lot. This originally started as part of the Cookbook Jam 2 in the Gamemaker Kitchen discord. I was unfortunately unable to finish due to real world responsibilities, but a minimal viable product requires finalizing an interchange format between editor and API,
Brushes/Widgets that allow more simple adjustments of points of the generated curve, a catmull-rom implementation for curve fitting pen/mouse strokes, and a way to integrate any used textures into the target project, or ensuring that loaded textures exist in the targetted project

## When will it be finished?
Never. Projects like this require continuous effort and never really finish, just as game engines are never "finished" but always evolving to best match user needs

## What sort of licence does this use?
Currently, I have not picked a license, but it will be a permissive one as this is intended to be a FOSS resource

## Any other important legal/licensing stuff

Links to included art assets as required by _their_ licenses

<a href="https://www.flaticon.com/free-icons/scissors" title="scissors icons">Scissors icons created by Good Ware - Flaticon</a>
<a href="https://www.flaticon.com/free-icons/line" title="line icons">Line icons created by Freepik - Flaticon</a>


rotate object by BUSAIRI from <a href="https://thenounproject.com/browse/icons/term/rotate-object/" target="_blank" title="rotate object Icons">Noun Project</a> (CC BY 3.0)

curve by Dika Neto from <a href="https://thenounproject.com/browse/icons/term/curve/" target="_blank" title="curve Icons">Noun Project</a> (CC BY 3.0)

Cut by David Swanson from <a href="https://thenounproject.com/browse/icons/term/cut/" target="_blank" title="Cut Icons">Noun Project</a> (CC BY 3.0)

Move by icon 54 from <a href="https://thenounproject.com/browse/icons/term/move/" target="_blank" title="Move Icons">Noun Project</a> (CC BY 3.0)

line tool by ghufronagustian from <a href="https://thenounproject.com/browse/icons/term/line-tool/" target="_blank" title="line tool Icons">Noun Project</a> (CC BY 3.0)

Fabric by Ayub Irawan from <a href="https://thenounproject.com/browse/icons/term/fabric/" target="_blank" title="Fabric Icons">Noun Project</a> (CC BY 3.0)

selection by Ricons from <a href="https://thenounproject.com/browse/icons/term/selection/" target="_blank" title="selection Icons">Noun Project</a> (CC BY 3.0)

connect by Gregor Cresnar from <a href="https://thenounproject.com/browse/icons/term/connect/" target="_blank" title="connect Icons">Noun Project</a> (CC BY 3.0)

rubber stamp by Tippawan Sookruay from <a href="https://thenounproject.com/browse/icons/term/rubber-stamp/" target="_blank" title="rubber stamp Icons">Noun Project</a> (CC BY 3.0)
