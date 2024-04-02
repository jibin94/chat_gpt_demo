import 'package:chat_gpt_demo/models/models_model.dart';
import 'package:chat_gpt_demo/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "gpt-3.5-turbo";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<OpenAIModels> modelsList = [];

  List<OpenAIModels> get getModelsList {
    return modelsList;
  }

  Future<List<OpenAIModels>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
