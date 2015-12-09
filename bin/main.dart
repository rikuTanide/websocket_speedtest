library wt_io;
import 'dart:io';
void main(){
  HttpServer.bind('ec2-52-192-212-82.ap-northeast-1.compute.amazonaws.com',80).then(onBind);

}

void onBind(HttpServer server){
  server.listen(onRequest);
}

void onRequest(HttpRequest req){
  if(WebSocketTransformer.isUpgradeRequest(req)){
    WebSocketTransformer.upgrade(req).then(onWebSocket);
  }

  var str_number = req.uri.queryParameters['number'];

  try {
    req.response
      ..headers.add('Access-Control-Allow-Origin','*')
      ..write(twice(str_number))
      ..close();
  }catch(e){
    req.response.close();
  }

}

void onWebSocket(WebSocket ws){
  ws.listen((str) => onWebSocketData(ws ,str));
}

void onWebSocketData(WebSocket ws , String str){
  ws.add(twice(str));
}

String twice(String str_number){
  var int_number = int.parse(str_number);
  return (int_number * 2).toString();
}