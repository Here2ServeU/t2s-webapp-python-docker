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
