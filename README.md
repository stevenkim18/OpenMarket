# 서버 api 데이터 통신 모델 구현하기

## 💻 구현 사항

- [서버 api 문서](https://docs.google.com/spreadsheets/d/1_l6aPfEUchSF_ymIp0DjyH8Ic00GIoqvd8dO9f7_sx4/edit#gid=1153044612)를 참고하여 네트워크와 통신을 하는 모델 구현(NetworkManager)
    - 상품 목록 조회
    - 상품 상세정보 조회
    - 상품 등록(Muti-part form)
    - 상품 수정(Muti-part form)
    - 상품 삭제
- 네트워크 요청 응답 모델 구현
- 네트워크 통신 모델 테스트
    - 네트워크에 의존하지 않는 테스트

### UML(서버와 통신하는 요청 응답 모델에 대한)

![Uml](https://user-images.githubusercontent.com/35272802/133461765-ad6d4227-2fac-4a29-bbca-3826e723e246.png)

### 테스트 항목

- 네트워크와 통신을 하는 모델인 `NetworkManager` 테스트 항목들
![스크린샷 2021-09-15 오후 11 43 21](https://user-images.githubusercontent.com/35272802/133461910-116616af-7e56-47be-bccc-09a8164dd736.png)


테스트 커버리지
![테스트 커버리지](https://user-images.githubusercontent.com/35272802/133461915-db2fe7de-d838-44ad-bd68-947b6eff224b.png)

## 🔑 학습 키워드

- URLSession
- Muti-part form-data
- Unit-Test
- Test Double
- protocol associated type
- URLProtocol

## 📖 학습 내용

### Muti-Part/form-data

Html코드를 사용해서 서버로 데이터를 보낼 때 `<form>` 태그를 사용해서 보낸다. `<form>` 속성에는 `enctype` 있는데 http 메소드에서 POST로 보낼 때 http body에 들어갈 데이터의 형식을 지정해 주는 속성이다. 디폴트 값은 `application/x-www-form-urlencoded` 이다. 이 속성은 key-value형식으로 보내기 용이하다(&를 구분자로 사용한다.) 하지만 이미지나 파일과 같은 바이너리 데이터는 보낼 수가 없다(이미지도 내부적으로는 숫자로 되어있고 엄청 긴 바이너리 코드로 되어 있다). 그래서 사용되는 속성이 `multipart/form-data` 이다.

`multipart/form-data` 예시

![멀티파트](https://user-images.githubusercontent.com/35272802/133462426-ef62cd76-7a23-4ae0-bf20-230770098a26.png)


### Test Double

![테스트대역1](https://user-images.githubusercontent.com/35272802/133462098-e5d60108-bf73-445d-80eb-d02a6ac051f7.png)

![테스트대역2](https://user-images.githubusercontent.com/35272802/133461925-03135ba6-654c-4749-b22f-21a0df6896fb.png)


- 개념에 대해서 구분하는 그렇게 중요하지 않음.
- 필요에 따라 적재적소에 사용하면 됨.
- 이 프로젝트에는 Mock 객체를 만듬.

### URLProtocol

정의

- URL 데이터를 처리할 수 있는 객체를 만들어주는 swift에서 제공하는 low-level의 객체이다.
- 단독으로 사용해서는 안되고 반드시 상속을 해서 사용해야 한다.

URLProtocol 사용해서 Mock 객체 만들기

```swift
class MockURLProtocol: URLProtocol {
  // Mock response을 전달할 타입을 선언한다.
  static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?  

  override class func canInit(with request: URLRequest) -> Bool {
    // 외부에서 만들어지는 request를 처리할 수 있는지 여부
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    // 어떤 request를 리턴할 것인지 알려주는 함수(우리는 테스트를 위해서 매번 request를 만들어 준다)
    return request
  }

  // Mock response를 만들어서 URLClient에게 전달할 것 이 함수 안에서 해야 함.
  override func startLoading() {
	guard let handler = MockURLProtocol.requestHandler else {
	    fatalError("Handler is unavailable.")
	}
    
	  do {
		  // 외부에서 만들어준 Mock response를 호출 한다.
	    let (response, data) = try handler(request)
    
	    // 클라이언트에 response 전달
	    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    
	    if let data = data {
	      // 클라이언트에서 data 전달
	      client?.urlProtocol(self, didLoad: data)
	    }
    
	    // 응답이 마무리 되었다는 것을 알려줌
	    client?.urlProtocolDidFinishLoading(self)
	  } catch {
	    client?.urlProtocol(self, didFailWithError: error)
	  }
  }

  override func stopLoading() {
    // request가 끝나거나 취소 되었을 때 호출되는 함수
  }
}
```

URLProtocol을 채택한 Mock 객체에 보낼 response 만들기

```swift
MockURLProtocol.requestHandler = { request in
	// 네트워크 요철을 한 URLRequest가 넘어옴(여기서 request에 대한 테스트 진행 가능)
    
	// 가짜 응답을 만들어서 리턴함.
	let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
	return (response, Data())
}
```

MockURLProtocol을 사용해서 MockURLSession 만들기

```swift
let configuration = URLSessionConfiguration.ephemeral
configuration.protocolClasses = [MockURLProtocol.self]
let mockUrlSession = URLSession(configuration: configuration)
networkManager = NetworkManager(session: mockUrlSession)
```

- 이렇게 세팅을 마치고 urlSession을 기존과 동일한 방식으로 요청을 하면 Mock 객체를 사용해서 미리 설정해둔 응답과 데이터 전달이 된다. → 이렇게 하면 네트워크에 의존하지 않는 테스트를 할 수 있다.

## 🤔 고민한 점

### 요청 응답 모델을 어떻게 구현 할까? 어디까지 나눌까?

- 이전 프로젝트에서는 요청 요청 모델을 각각 하나씩 만들어서 그곳에서 다 처리를 하려고 하였다. 그러다 보니 모델이 너무 커졌다.
- 그래서 이번에는 프로토콜로 공통된 부분들을 빼고 이를 채택하게 하였다. → 프로토콜이 많아졌다 → 네트워크매니저에서 파라미터로 넘길 때 프로토콜 타입을 채택하니 수월해졌다.

### 요청 응답 모델 프로토콜의 이름을 어떻게 지을까?

- 네이밍을 하는 것은 매번 어렵다. 프로토콜의 이름을 지어줘야 하는데... API Design Guidelines 을 보니

```
- Protocols that describe what something is should read as nouns (e.g. Collection).
- Protocols that describe a capability should be named using 
  the suffixes able, ible, or ing (e.g. Equatable, ProgressReporting).
```

형용사 혹은 명사로 지어주라고 되어 있었다. 요청 응답 모델은 프로퍼티들만 가지고 있음으로 형용사는 어울리지 않는 것 같아서 명사로 지어주었다. 그런데 짖다 보니 프로토콜도 모델 구조체도 모두 `Information` 이 들어가게 지어 주었다.. 맞는 건지 모르겠다.

### NetworkManager는 어느 역할까지 해야 할까? 함수는 어떻게 나눌까?

- 이전 프로젝트에서는 서버 api에 요청을 하고 데이터를 받아서 파싱하는 역할까지 담당했었다. 그러다 보니 하나의 함수에서 구현하자니 함수가 너무 복잡해지고 각 요청 별로 함수를 만들었더니 중복되는 코드들이 많았다. 그래서 이번에는 파싱을 따로 해주고 요청 성공 했을 시 데이터까지만 넘겨주게 했다. 이렇게 했더니 코드가 많이 깔끔해진 것 같다.
- 처음에는 서버 api의 요청하는 함수를 한개만 만들고 그곳에서 모든 요청을 처리하려고 했다. 그런데 함수가 복잡해졌고, 조금 세분화 해서 함수를 구현하려고 했다. 크게 조회 요청, 멀티파트 업로드 요청, json 요청 3가지로 나눠서 함수를 구현하였다.

    ```swift
    func request(_ endPoint: EndPoint, 
    		 completion: @escaping ResultHandler)
		 
    func upload(form: MutipartForm, 
    		_ endPoint: EndPoint, 
    		completion: @escaping ResultHandler)
    ```

### 네트워크와 무관한 테스트를 할 때 MockURLSession을 만들까? URLProtocol을 사용할까?

MockURLSession

- Mock 객체를 만들면 테스트하기가 매우 용이하고 자료도 많다.
- 하지만 치명적이게도.. URLSessionDatatask의 이니셜라이즈가 ios13부터 deprecated 되었다.

URLProtocol

- 그래서 결국 URLProtocol을 사용하기로 했다. 내가 원하는 요청과 응답을 만들어서 보낼 수 있다.
- URLRequest로 담아서 보낸 요청이 URLProtocol안에서 일부 처리되거나 없어지기는 하지만 아직까지는 못하는 테스트는 없는 것 같아서 사용하기로 했다.

### 상품 수정 요청을 테스트 할 때 어떻게 Mock 응답을 만들어 줄까?

서버에서 수행하는 상품 요청 프로세스

1. 상품 수정을 요청한다.
2. 요청을 받은 데이터 중에서 어떤 속성이 바뀌어야 하는지를 기존의 있는 데이터와 비교한다.
3. 업데이트 된 상품 정보를 다시 json 형식으로 변환해서 클라이언트에서 넘겨준다.

이러한 작업을 `MockURLProtocol.requestHandler` 안에서 해주어야 한다. 그럴러면 `multipart/form-data` 형식으로 오는 httpbody를 파싱을 해서 위에서 언급한 프로세스를 진행해야 한다. 직접 구현하기는 시간이 오려 걸려서 [오픈 소스](https://github.com/417-72KI/MultipartFormDataParser)를 찾아봤다. 시도를 해봤지만 내가 만든 형식과 맞지 않는지.. 계속 유효하지 않는 형식이라는 에러가 나서 일단 더미 데이터를 넘기는 테스트로 남겨두었다. 나중에 시간이 되면 오픈 소스 코드를 보고 서라도 직접 구현해서 테스트를 진행해 봐야겠다.

## 🚧 트러블 슈팅

### URLProtocol의 핸들러에서 error을 넘겨주었으나 응답에서 넘어오지 않는 문제

원인

- URLProtocol 구현부인 `startLoading()` 함수에서 error을 넘겨주지 않아서 생기는 문제였다.

해결책

- error을 URLProtocolClient 안에 있는 urlProtocol에 넘겨주었더니 해결되었다.

```swift
override func startLoading() {
	guard let handler = MockURLProtocol.requestHandler else {
		XCTFail("Handler is unavailable.")
		return
        }
        
        do {
            let (data, response, error) = try handler(self.request)
            
            if let response = response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            // error을 넘겨주었더니 해결
            if let error = error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
```

### URLProtocol을 사용해서 응답데이터 nil을 넘겨주어서 보냈는데 빈 Data() 인스턴스가 넘어오는 문제

참고자료

- [https://stackoverflow.com/questions/62406384/how-to-load-nil-data-with-a-urlprotocol-subclass](https://stackoverflow.com/questions/62406384/how-to-load-nil-data-with-a-urlprotocol-subclass)

원인

- `URLProtocol` 내부에서 무조건 Data 인스턴스를 만들어주는 것 같다.

해결책

- NetworkManager에서 데이터를 확인하는 부분에 데이터가 비어있는 여부까지 확인을 한다.

```swift
guard let data = data, !data.isEmpty else {
	return completion(.failure(.invalidData))
}
```

### protocol에서 associatedtype을 String, String?로 강제하는 것

원인

- 요청 모델을 만들 때 상품 등록과 수정의 속성들이 모두 같고 옵셔널인 것만 달라서 이것을 어떻게 공통으로 뺼 수 있을까를 고민했다. 그런 중에 protocol에 `associatedtype` 이 있다는 것을 알게 되었다. 이것을 사용해서 해당 원시 타입과 원시 타입의 옵셔널만을 채택하는 커스텀 protocol을 만들어서 사용하려고 했는데 옵셔널이 채택 되지 않는 것이다.

해결책(Thank to 수박)

- 동료인 수박이 알려주었다.

```swift
protocol Stringable {}

extension String: Stringable {}
extension Optional: Stringable where Wrapped == String {}
```

옵셔널도 하나의 구조체이기 그 안에 제너릭으로 타입이 들어오는 것이다. `where` 절을 사용해서 이를 강제해주면 해결된다.
