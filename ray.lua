import numpy as np
import matplotlib.pyplot as plt

# Vector utilities
def vec3(x, y, z):
    return np.array([x, y, z])

def subtract(v1, v2):
    return v1 - v2

def add(v1, v2):
    return v1 + v2

def multiply(v, scalar):
    return v * scalar

def dot(v1, v2):
    return np.dot(v1, v2)

def length(v):
    return np.linalg.norm(v)

def normalize(v):
    return v / length(v)

# Ray structure
def ray(origin, direction):
    return {'origin': origin, 'direction': direction}

# Sphere structure
def sphere(center, radius):
    return {'center': center, 'radius': radius}

# Ray-Sphere intersection
def intersectRaySphere(ray, sphere):
    oc = subtract(ray['origin'], sphere['center'])
    a = dot(ray['direction'], ray['direction'])
    b = 2 * dot(oc, ray['direction'])
    c = dot(oc, oc) - sphere['radius']**2
    discriminant = b**2 - 4 * a * c

    if discriminant < 0:
        return None  # No intersection
    else:
        t1 = (-b - np.sqrt(discriminant)) / (2 * a)
        t2 = (-b + np.sqrt(discriminant)) / (2 * a)

        return min(t1, t2)  # Return the nearest intersection

# Simple shading function
def shade(ray, hitPoint, normal):
    lightDir = normalize(vec3(-1, -1, -1))  # Light direction
    intensity = max(0, dot(normal, lightDir))  # Diffuse lighting
    return multiply(vec3(1, 0, 0), intensity)  # Red color

# Simple scene with one sphere and a light source
def render(width, height):
    cameraOrigin = vec3(0, 0, -5)  # Camera position
    sphere1 = sphere(vec3(0, 0, 0), 1)  # Sphere at the origin
    image = np.zeros((height, width, 3))

    for y in range(height):
        for x in range(width):
            px = (x - width / 2) / width
            py = (y - height / 2) / height
            rayDir = normalize(vec3(px, py, 1))  # Ray direction
            r = ray(cameraOrigin, rayDir)

            t = intersectRaySphere(r, sphere1)

            if t:
                hitPoint = add(r['origin'], multiply(r['direction'], t))
                normal = normalize(subtract(hitPoint, sphere1['center']))
                image[y, x] = shade(r, hitPoint, normal)
            else:
                image[y, x] = vec3(0, 0, 0)  # Background color (black)

    return image

# Run the renderer
width, height = 400, 200  # Image resolution
image = render(width, height)

# Display the image
plt.imshow(image)
plt.axis('off')
plt.show()
