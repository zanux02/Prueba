class Config 
{
  static const String baseUrl = 'http://192.168.6.40:5173/horarios';

  static Uri getProfessorsUrl() 
  {
    return Uri.parse('$baseUrl/get/teachers');
  }

  static Uri getCoursesUrl() 
  {
    return Uri.parse('$baseUrl/get/courses');
  }
}
