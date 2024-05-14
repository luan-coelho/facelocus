import asyncio
import aiohttp

# Lista de URLs para serem testadas
urls = [
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=66/facephoto.jpg&profile_face_photo=66/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=55/93c1c7fb-205b-43a9-9bcd-2e30bda66f13/facephoto.jpg&profile_face_photo=55/93c1c7fb-205b-43a9-9bcd-2e30bda66f13/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=55/93c1c7fb-205b-43a9-9bcd-2e30bda66f13/facephoto.jpg&profile_face_photo=55/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=55/facephoto.jpg&profile_face_photo=55/93c1c7fb-205b-43a9-9bcd-2e30bda66f13/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=55/facephoto.jpg&profile_face_photo=55/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=56/23c26392-502d-433a-ab35-50bff93e2b55/facephoto.jpg&profile_face_photo=56/23c26392-502d-433a-ab35-50bff93e2b55/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=56/23c26392-502d-433a-ab35-50bff93e2b55/facephoto.jpg&profile_face_photo=56/2b90bab3-4b76-4b9c-a69f-f5425a7848bb/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=56/23c26392-502d-433a-ab35-50bff93e2b55/facephoto.jpg&profile_face_photo=56/2d4648f0-7e02-452c-a760-9387c48e0ab3/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=56/23c26392-502d-433a-ab35-50bff93e2b55/facephoto.jpg&profile_face_photo=56/35497008-199a-4951-8e29-422648569b36/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=56/23c26392-502d-433a-ab35-50bff93e2b55/facephoto.jpg&profile_face_photo=56/489f441f-e5d8-4a14-b1d9-c1ee525fca26/facephoto.jpg',
    'http://ec2-18-230-249-227.sa-east-1.compute.amazonaws.com:5000/facerecognition/check-faces?face_photo=56/23c26392-502d-433a-ab35-50bff93e2b55/facephoto.jpg&profile_face_photo=56/6c085d97-647d-438d-8d05-cb41bcf35735/facephoto.jpg',
]

async def fetch(session, url):
    async with session.get(url) as response:
        return await response.text()

async def main():
    async with aiohttp.ClientSession() as session:
        tasks = [fetch(session, url) for url in urls]
        responses = await asyncio.gather(*tasks)
        for response in responses:
            print(response)

if __name__ == "__main__":
    asyncio.run(main())
