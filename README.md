# T2S Course Enrollment App Using Docker

This repository contains three different methods to containerize and deploy a Flask-based course enrollment application for **T2S Courses**.

---
## Features:
- Students can enroll in T2S courses through a web form.
- The application is built using Flask.
- Three containerization methods are used:
  - **Method 1:** Using a `Dockerfile`
  - **Method 2:** Using `Docker Compose`
  - **Method 3:** Using CLI Commands (without Dockerfile or Compose)

---

## **Method 1: Containerizing Using a Dockerfile**
This method builds and runs a Docker container using a **Dockerfile**.

### **1. Project Structure**
```txt
t2s-enrollment-dockerfile/
│── app/
│   ├── app.py
│   ├── requirements.txt
│   ├── templates/
│   │   ├── index.html
│── Dockerfile
```
### **2. Flask Application (`app/app.py`)**
```python
from flask import Flask, render_template, request

app = Flask(__name__)

students = []

@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        name = request.form.get("name")
        course = request.form.get("course")
        students.append({"name": name, "course": course})
    return render_template("index.html", students=students)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

### 3. HTML Template (app/templates/index.html)
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enroll in Our Program</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #0073e6;
            color: white;
            padding: 10px 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        header img {
            height: 50px;
            margin-right: 10px;
        }
        header h1 {
            margin: 0;
            font-size: 24px;
        }
        form {
            max-width: 400px;
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        input, select {
            width: 100%;
            margin: 10px 0;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            background: #0073e6;
            color: white;
            font-size: 16px;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background: #005bb5;
        }
        .success-message {
            font-size: 18px;
            color: #28a745;
        }
    </style>
</head>
<body>
    <header>
        <h1>Enroll in Our Program</h1>
    </header>

    <form id="enrollmentForm">
        <input type="text" id="firstName" name="firstName" placeholder="First Name" required>
        <input type="text" id="lastName" name="lastName" placeholder="Last Name" required>
        <input type="tel" id="phone" name="phone" placeholder="Phone Number" required>
        <input type="email" id="email" name="email" placeholder="Email Address" required>
        <select id="course" name="course" required>
            <option value="" disabled selected>Select a Course</option>
            <option value="DevOps">DevOps</option>
            <option value="Cloud">Cloud</option>
        </select>
        <button type="submit">Submit</button>
    </form>

    <div id="successMessage" class="success-message" style="display: none;">
        Thank you for enrolling! Your data has been successfully submitted.
    </div>

    <script>
        const form = document.getElementById('enrollmentForm');
        const successMessage = document.getElementById('successMessage');

        form.addEventListener('submit', async (event) => {
            event.preventDefault(); // Prevent page reload

            const data = {
                firstName: document.getElementById('firstName').value,
                lastName: document.getElementById('lastName').value,
                phone: document.getElementById('phone').value,
                email: document.getElementById('email').value,
                course: document.getElementById('course').value
            };

            try {
                const response = await fetch('https://72su899n2k.execute-api.us-east-1.amazonaws.com/dev/enroll', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data),
                });

                if (response.ok) {
                    successMessage.style.display = 'block';
                    form.reset();
                } else {
                    alert('Error submitting the form. Please try again.');
                }
            } catch (error) {
                alert('Unable to submit form. Please check your connection and try again.');
            }
        });
    </script>
</body>
</html>
```
### 4. Dependencies (app/requirements.txt)
```txt
flask
```
### 5. Create a Dockerfile
```go
FROM python:3.9

WORKDIR /app

COPY app/ /app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]
```

### 6. Build and Run
```bash
docker build -t t2s-enrollment .
docker run -d -p 5000:5000 t2s-enrollment
```

---
## **Method 2: Containerizing Using Docker Compose**

This method runs the application with Docker Compose and a MySQL database.

### 1. Project Structure
```txt
t2s-enrollment-compose/
│── app/
│   ├── app.py
│   ├── requirements.txt
│   ├── templates/
│   │   ├── index.html
│── docker-compose.yml
│── Dockerfile
```
### 2. Flask Application (app/app.py)
```python
from flask import Flask, render_template, request
import mysql.connector

app = Flask(__name__)

db = mysql.connector.connect(
    host="db",
    user="root",
    password="password",
    database="t2s_courses"
)

cursor = db.cursor()
cursor.execute("CREATE TABLE IF NOT EXISTS students (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), course VARCHAR(255))")
db.commit()

@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        name = request.form.get("name")
        course = request.form.get("course")
        cursor.execute("INSERT INTO students (name, course) VALUES (%s, %s)", (name, course))
        db.commit()
    
    cursor.execute("SELECT name, course FROM students")
    students = cursor.fetchall()
    return render_template("index.html", students=students)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```
### 3. Update Dockerfile
```go
FROM python:3.9

WORKDIR /app

COPY app/ /app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]
```
### 4. Create docker-compose.yml
```yml
version: "3.8"

services:
  web:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - db

  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: t2s_courses
```
### 5. Run the Application
```bash
docker-compose up -d
```

---
## **Method 3: Containerizing Using Only CLI Commands**

This method runs the Flask app inside a container without a Dockerfile or Docker Compose.

### 1. Create a Flask App
```bash
mkdir t2s-cli-app && cd t2s-cli-app
nano app.py
```
- Paste the following code:
```python
from flask import Flask, render_template, request

app = Flask(__name__)

students = []

@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        name = request.form.get("name")
        course = request.form.get("course")
        students.append({"name": name, "course": course})
    return render_template("index.html", students=students)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```
### 2. Create an HTML Template
```bash
mkdir templates
nano templates/index.html
```
- Paste the following HTML:
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enroll in Our Program</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #0073e6;
            color: white;
            padding: 10px 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        header img {
            height: 50px;
            margin-right: 10px;
        }
        header h1 {
            margin: 0;
            font-size: 24px;
        }
        form {
            max-width: 400px;
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        input, select {
            width: 100%;
            margin: 10px 0;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            background: #0073e6;
            color: white;
            font-size: 16px;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background: #005bb5;
        }
        .success-message {
            font-size: 18px;
            color: #28a745;
        }
    </style>
</head>
<body>
    <header>
        <h1>Enroll in Our Program</h1>
    </header>

    <form id="enrollmentForm">
        <input type="text" id="firstName" name="firstName" placeholder="First Name" required>
        <input type="text" id="lastName" name="lastName" placeholder="Last Name" required>
        <input type="tel" id="phone" name="phone" placeholder="Phone Number" required>
        <input type="email" id="email" name="email" placeholder="Email Address" required>
        <select id="course" name="course" required>
            <option value="" disabled selected>Select a Course</option>
            <option value="DevOps">DevOps</option>
            <option value="Cloud">Cloud</option>
        </select>
        <button type="submit">Submit</button>
    </form>

    <div id="successMessage" class="success-message" style="display: none;">
        Thank you for enrolling! Your data has been successfully submitted.
    </div>

    <script>
        const form = document.getElementById('enrollmentForm');
        const successMessage = document.getElementById('successMessage');

        form.addEventListener('submit', async (event) => {
            event.preventDefault(); // Prevent page reload

            const data = {
                firstName: document.getElementById('firstName').value,
                lastName: document.getElementById('lastName').value,
                phone: document.getElementById('phone').value,
                email: document.getElementById('email').value,
                course: document.getElementById('course').value
            };

            try {
                const response = await fetch('https://72su899n2k.execute-api.us-east-1.amazonaws.com/dev/enroll', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data),
                });

                if (response.ok) {
                    successMessage.style.display = 'block';
                    form.reset();
                } else {
                    alert('Error submitting the form. Please try again.');
                }
            } catch (error) {
                alert('Unable to submit form. Please check your connection and try again.');
            }
        });
    </script>
</body>
</html>
```
### 3. Run Flask App in a Docker Container
```bash
docker pull python:3.9

docker run -it --rm -p 5000:5000 -v "$(pwd)":/app -w /app python:3.9 \
sh -c "pip install flask && python app.py"
```

- To run in detached mode:
```bash
docker run -d -p 5000:5000 -v "$(pwd)":/app -w /app python:3.9 \
sh -c "pip install flask && python app.py"
```

---
## Conclusion

This README provides three different methods for deploying a Flask-based course enrollment application using Docker:
1.	Method 1: Dockerfile-based deployment.
2.	Method 2: Docker Compose-based deployment with MySQL.
3.	Method 3: Running directly using CLI commands.

Choose the method that best fits your workflow!
