# Edu-App

**Edu-App** creates a platform for students who seek individual attention to get help from tutors worldwide. It also enables people skilled in various subjects to teach and earn money. 
The app connects students and tutors in a seamless way, allowing students to browse through tutor profiles, book trial sessions, and take lessons, while tutors can upload their qualifications, set availability, and offer paid teaching sessions.

# Project Description

**Edu-App** is a platform designed to connect students with tutors for personalized, one-on-one learning experiences. The application allows students to find tutors who meet their learning needs, while tutors can share their knowledge and earn money through teaching sessions and content contributions.

## What the Application Does

### For Students:
- **Login:** Students can log in using their Google account.
- **Welcome Emails:** Upon signing up, students receive a welcome email.
- **Profile Management:** Students can edit their profiles to update their preferences and personal information.
- **Tutor Selection:** Students can browse through available tutors, filter them based on experience, subject areas, and personal preferences.
- **Book Sessions:** Students can book one-on-one sessions with selected tutors and attend these sessions via Google Meet.
- **Chat Feature:** Students can chat with tutors for any clarification or communication.
- **Session Management:** Students can reschedule sessions based on tutor availability.
- **News Teller Subscription:** Students can subscribe to topics of interest and receive updates on the latest learning materials, blogs, and subject-related content.
- **Tutor Reviews:** Students can rate and review tutors based on their session experience.

### For Tutors:
- **Login:** Tutors can log in using their Google account.
- **Welcome Emails:** Tutors receive a welcome email upon signing up.
- **Profile Management:** Tutors can edit their profiles to reflect their expertise, qualifications, and availability.
- **Session Creation:** Tutors can create and manage sessions based on their availability, and they receive notifications when a student books a session.
- **Session Management:** Tutors can delete or update their session schedules as needed.
- **Lesson Delivery:** Tutors can conduct their sessions via Google Meet.
- **Content Contribution:** Tutors can upload learning materials and publish blogs in their area of expertise.
- **Payment:** Tutors can earn money based on the sessions they conduct and for contributing learning materials and blogs to the community. Payments are based on their activity and knowledge-sharing contributions.

## Technologies Used

- **Ballerina Persist:** Used to create and manage database operations.
- **Docker:** Utilized to handle the FTP server and Kafka server.
- **Google OAuth:** Integrated to manage user authentication.
- **Gmail API:** Used to send onboarding emails and notify students about new updates and news.
- **Google Calendar:** Integrated for scheduling tutoring sessions.
- **FTP Server:** Used to store documents uploaded by tutors, such as learning materials.
- **Kafka:** Utilized to publish metadata as emails to students subscribed to specific topics.
- **GraphQL Interceptors:** Implemented to handle role-based authentication at the GraphQL service level.
- **HTTP Interceptors:** Used to check for the presence of the authorization header in HTTP requests.

## Challenges and Future Features

- **Pricing Strategy:** Currently, there is no pricing strategy implemented. Students can book and attend sessions for free, and tutors are not yet getting paid for their conducted sessions or contributions to the community.
- **Future Plans:** Implement a pricing mechanism where students can pay for booked sessions, and tutors can be compensated for both their teaching sessions and content contributions. Additionally, improve session scheduling and payment workflows to enhance the overall user experience.

# How to Run

To set up and run the **Edu-App**, follow these steps:

## 1. Create the `Config.toml` File

Create a `Config.toml` file in the root directory of the project with the following values:

```toml
clientId = ""
clientSecret =  ""
refreshToken = ""
kafkaTopic = ""
kafkaGroupId = ""

[educational_app_backend.datasource]
host = ""
port = 0
user = ""
password = "0"
database = ""

