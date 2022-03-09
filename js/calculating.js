
function K(c,u) {
    let numerator = 0;
    let denom = 0;
    for(let l = 0; l <= c-1; l++) {
        numerator += (Math.pow(u, l))/(factorialize(l));
    }
    for(let l = 0; l <= c; l++) {
        denom += (Math.pow(u, l))/(factorialize(l));
    }
    // console.log('num',numerator)
    // console.log('denom',denom)
    return numerator / denom;
}

function C(c,u,rho) {
    // console.log('k', K(c, u))
    return ((1-K(c,u))/(1-(rho*K(c,u))))
}

function factorialize(num) {
    if (num < 0) 
          return -1;
    else if (num == 0) 
        return 1;
    else {
        return (num * factorialize(num - 1));
    }
}

function doMath(c, l) {
    var lambda = 1 / l // mean arrival rate, 1/inter-arrivL-TIME, one person per x minutes
    var mu = 1 / 20 // mean service rate, ^^

    // From Heidi's paper
    // var lambda = 1 / 10 // mean arrival rate, 1/inter-arrivL-TIME
    // var mu = 1 / 8 // mean service rate, ^^


    var u = lambda / mu
    var rho = lambda / (c*mu);
    let firstThing = C(c,u,rho)/c;
    let secondThing = 1/(mu*(1-rho));
    let lastThing = 1/mu;
    // console.log('rho',rho)
    // console.log(firstThing, secondThing, lastThing)
    console.log('when c=',c,'arrival',l,((firstThing*secondThing)+lastThing).toFixed(20), 'MINUTES')
}

for(let i = 7.64; i < 7.66; i = i + 0.0001) {
    doMath(3,i)
}

// 1 server = 1 client per 30 m
// 2 servers = 1 client 12.25ish m = ~4.9 cli/h
// 3 servers = 1 client between 7.65ish m = ~7.84 cli/h

// doMath(2)
// doMath(3)
// doMath(4)
// doMath(5)
// doMath(6)

// var lambda = 10
// var mu = 3

// var lambda = 1/6
// var mu = 1/20

// var lambda = 1/10
// var mu = 1/3


// let rho = lambda / mu
// let Lq = (rho*rho)/ (1-rho)
// console.log('lq',Lq)
// console.log('Wq', Lq / lambda)
// console.log('W', (Lq / lambda) + (1 / mu))
// How to get this to "net lambda of k server"???
