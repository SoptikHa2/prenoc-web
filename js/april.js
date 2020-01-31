let d = new Date();
if(d.getMonth() != 3 || d.getDate() != 1)
{
    console.log("Here comes nothing");
}
else
{
    executeApril();
}

function executeApril() {
    console.log("It's party time!!");

    document.write('<link rel="stylesheet" type="text/css" href="css/april.css">');

    sayori(0.05);
}

function sayori(chance) {
    console.log("JUST MONIKA");
    if(Math.random() <= chance) {
        console.log("Sayori STRIKES");
        document.body.innerHTML = '<img class="disappearing" src="img/screenshot0060.png" />' + document.body.innerHTML;

        if(chance < 1.5)
            window.setTimeout(() => sayori(chance + 0.2), 2000);
    }
}
