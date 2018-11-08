import math

sh = None
maxima = []
stopped = False
recording = False

def setup():
    # fullScreen(P2D)
    size(750,750, P2D)
    # smooth()
    global sh
    sh = loadShader("contour_frag.glsl")
    reset()

def draw():
    background(0xEEEEEE)
    global sh, maxima
    maxima = [(m[0]+m[4], m[1]+m[5], m[2], m[3], m[4], m[5]) for m in maxima]
    shader(sh)
    sh.set('peak1', *maxima[0][:4])
    sh.set('peak2', *maxima[1][:4])
    sh.set('peak3', *maxima[2][:4])
    sh.set('heights', 1.0, 1.0, 1.0)
    rect(0,0,width,height)
    if recording:
        saveFrame('contour_frames/c####.tif')
        resetShader()
        noStroke()
        fill(0xFF0000)
        ellipse(30,30,30,30)
    
    # resetShader()
    # for m in maxima:
    #     colorMode(RGB)
    #     stroke(0xFF0000)
    #     # noStroke()
    #     rect(m[0], m[1], 8,8) 

def keyReleased():
    if key == ' ':
        reset()
    elif key == 's':
        global stopped
        stopped = not stopped
        if stopped:
            noLoop()
        else:
            loop()
    elif key == 'm':
        global recording
        recording = not recording

def reset():
    stddev = width/4
    var_var = 0.5 * stddev
    maxima_height = 1
    move_rate = 0
    move_var = 0.35

    def rng(x,r):
        return x + random(-r, r)
    
    global sh, maxima
    maxima = [(int(random(width)), 
               int(random(height)), 
               rng(stddev,var_var), 
               rng(stddev,var_var),
               rng(move_rate,move_var),
               rng(move_rate,move_var)) for _ in range(3)]
    print 'RESET: ' + str(maxima)

def ptog(p):
    return p % width, int(p / width)

def distance(p0, p1):
    return dist(p0[0], p0[1], p1[0], p1[1])

def gauss1d(dev,stddev):
    var = stddev ** 2
    return (1.0/sqrt(2*math.pi*var)) * math.exp(-(dev ** 2)/(2*var))

def gauss2d(ds, sds):
    return (1.0/(2*math.pi * sds[0] * sds[1])) * math.exp( -0.5 * ((ds[0] ** 2 / sds[0] ** 2) + (ds[1] ** 2 / sds[1] ** 2)))