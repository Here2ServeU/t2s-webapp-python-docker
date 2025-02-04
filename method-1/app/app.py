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
