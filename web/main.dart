library wt_html;

import 'dart:html';


String url = "//ec2-52-192-212-82.ap-northeast-1.compute.amazonaws.com";
int max = 1000;
int sir_http_count = max;
int sir_ws_count = max;
int par_http_count = max;
int par_ws_count = max;

DateTime sir_http_start, sir_http_end, par_http_start, par_http_end,
    sir_ws_start, sir_ws_end, par_ws_start, par_ws_end;


void main() {
  sir_http_start = new DateTime.now();
  timelog(sir_http_start);
  requestSirHttp();
}

void requestSirHttp() {
  if (sir_http_count > 0) {
    HttpRequest.getString(url + "?number=$sir_http_count").then((_) =>
        requestSirHttp());
    sir_http_count --;
  } else {
    var sir_http_end = new DateTime.now();
    timelog(sir_http_end);
    betweenlog(sir_http_end, sir_http_start);
    requestSirWS();
  }
}

void requestSirWS() {
  var ws = new WebSocket("ws:" + url);
  sir_ws_start = new DateTime.now();
  timelog(sir_ws_start);
  ws.onOpen.listen((_) {
    timelog(new DateTime.now());
    ws.send(sir_ws_count --);
  });
  ws.onMessage.listen((_) {
    if (sir_ws_count > 0) {
      ws.send(sir_ws_count --);

    } else {
      sir_ws_end = new DateTime.now();
      timelog(sir_ws_end);
      betweenlog(sir_ws_end, sir_ws_start);
      requestParWS();
    }
  });
}

void requestParWS(){
  par_ws_start = new DateTime.now();
  timelog(par_ws_start);
  var ws = new WebSocket("ws:" + url);
  ws.onOpen.listen((_){
    for(var x = 0 ; x < max ; x ++){
      ws.send(x);
    }
  });
  ws.onMessage.listen((_){
    par_ws_count --;
    if(par_ws_count == 0){
      par_ws_end =  new DateTime.now();
      timelog(par_ws_end);
      betweenlog(par_ws_end , par_ws_start);
      requestParHttp();
    }
  });
}

void requestParHttp(){
  par_http_start = new DateTime.now();
  timelog(par_http_start);

  for(var x = 0 ; x < max ; x ++){
    HttpRequest.getString(url + "?number=$x").then((_){
      par_http_count --;
      if(par_http_count == 0){
        par_http_end =  new DateTime.now();
        timelog(par_http_end);
        betweenlog(par_http_end , par_http_start);
      }
    });
  }
}

void timelog(DateTime dt) {
  document.body.append(new DivElement()
    ..text = dt.toString());
}

void betweenlog(DateTime dt1, DateTime dt2) {
  document.body.append(new DivElement()
    ..text = (dt1.millisecondsSinceEpoch - dt2.millisecondsSinceEpoch)
        .toString());
}