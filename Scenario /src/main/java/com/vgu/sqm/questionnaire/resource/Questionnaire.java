package com.vgu.sqm.questionnaire.resource;

import com.vgu.sqm.questionnaire.api.QuestionnaireApi;
import com.vgu.sqm.questionnaire.api.ResourceApi;
import com.vgu.sqm.questionnaire.utils.JsonUtils;
import com.vgu.sqm.questionnaire.utils.StringUtils;
import java.util.regex.Matcher;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.stream.JsonParsingException;

public class Questionnaire extends Resource {
  private String LecturerID;
  private String ClassID;
  private int QuestionnaireID;
  private char gender;
  private int[] answers;
  private String comment;

  public static final String p_LecturerID = "LecturerID";
  public static final String p_ClassID = "ClassID";
  public static final String p_QuestionnaireID = "QuestionnaireID";
  public static final String p_gender = "gender";
  public static final String p_Attendance = "Attendance";
  public static final String p_answers = "answers";
  public static final String p_comment = "comment";

  public Questionnaire(String LecturerID, String ClassID, int QuestionnaireID, char gender,
      int[] answers, String comment) {
    this.LecturerID = LecturerID;
    this.ClassID = ClassID;
    this.QuestionnaireID = QuestionnaireID;
    this.gender = gender;
    this.answers = answers;
    this.comment = comment;
  }

  public String getLecturerID() {
    return this.LecturerID;
  }

  public String getClassID() {
    return this.ClassID;
  }

  public int getQuestionnaireID() {
    return this.QuestionnaireID;
  }

  public char getGender() {
    return this.gender;
  }

  public int[] getAnswers() {
    return this.answers;
  }

  public String getComment() {
    return this.comment;
  }

  /**
   * Parse a JSON object and turn it into an Questionnaire object
   *
   * @param json The JSON object to be turned into a Questionnaire object
   * @return a Questionnaire object corresponding to the provided JSON object
   */
  public static Questionnaire jsonToResource(JsonObject json) throws MalformedResourceJsonException {
    try {
      String LecturerID = json.getJsonString(ResourceApi.p_LecturerID).getString();
      String ClassID = json.getJsonString(ResourceApi.p_ClassID).getString();
      // Placeholder QID, to be auto-incremented
      int QuestionnaireID = 0;
      // Gender should be a single character
      char gender = json.getJsonString(QuestionnaireApi.p_Gender).getChars().charAt(0);
      String comment = json.getJsonString(QuestionnaireApi.p_Comment).getString();
      JsonArray jsonAnswers = json.getJsonArray(QuestionnaireApi.p_Answers);
      if (jsonAnswers.size() != 18) {
        throw new MalformedResourceJsonException(
            "There must be exactly 18 answers in the 'qa' array");
      }
      int[] answers = new int[18];
      for (int i = 0; i < answers.length; i++) {
        answers[i] = jsonAnswers.getInt(i);
      }
      if (!Questionnaire.checkParametersAreValid(LecturerID, ClassID, gender, answers, comment)) {
        throw new MalformedResourceJsonException(
            StringUtils.messageInvalidParameters(ResourceApi.p_LecturerID, ResourceApi.p_ClassID,
                QuestionnaireApi.p_Gender, QuestionnaireApi.p_Answers, QuestionnaireApi.p_Comment));
      }

      return new Questionnaire(LecturerID, ClassID, QuestionnaireID, gender, answers, comment);
    } catch (MalformedResourceJsonException e) {
      throw e;
    } catch (NullPointerException e) {
      throw new MalformedResourceJsonException(
          StringUtils.messageMissingParameters(ResourceApi.p_LecturerID, ResourceApi.p_ClassID,
              QuestionnaireApi.p_Gender, QuestionnaireApi.p_Comment, QuestionnaireApi.p_Answers));
    } catch (ClassCastException e) {
      throw new MalformedResourceJsonException("Answers must be integers");
    } catch (JsonParsingException e) {
      throw new MalformedResourceJsonException();
    }
  }

  public JsonObject exportResourceJson() {
    JsonObjectBuilder builder = Json.createObjectBuilder();
    builder.add(Questionnaire.p_LecturerID, this.LecturerID);
    builder.add(Questionnaire.p_ClassID, this.ClassID);
    builder.add(Questionnaire.p_QuestionnaireID, this.QuestionnaireID);
    builder.add(Questionnaire.p_gender, this.gender);
    builder.add(Questionnaire.p_answers, JsonUtils.arrayToJson(this.answers));
    builder.add(Questionnaire.p_comment, this.comment);
    JsonObject obj = builder.build();
    return obj;
  }

  /** Checks that the provided parameters are valid */
  public static boolean checkParametersAreValid(
      String LecturerID, String ClassID, char gender, int[] answers, String comment) {
    return
        // LecturerID
        Resource.isIdValid(LecturerID)
        // ClassID
        && Resource.isIdValid(ClassID)
        // gender
        && (gender == 'M' || gender == 'F' || gender == 'O')
        // questionnaire answers (0 == N/A)
        && isAllAnswersValid(answers)
        // Comment max character count = 500
        && comment.length() <= 500;
  }

  private static boolean isAllAnswersValid(int answers[]) {
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] > 5) {
        return false;
      }

      if ((i >= 5) && (i <= 7) && (answers[i] <= 0)) {
        return false;
      }

      if (answers[i] < 0) {
        return false;
      }
    }

    return true;
  }
}
