# CollectionView 리스트 뷰 구현하기

## 💻 구현 사항

- 서버 api와 네트워크 통신을 통해 상품 정보를 불러옴.
- CollectionView를 사용해서 상품의 정보를 사용자에게 리스트 형식으로 보여줌.
- 무한 스크롤 구현
- CollectionView 최상단에서 아래로 스크롤시 새로고침 구현

### 구현화면
![리스트뷰](https://user-images.githubusercontent.com/35272802/136805052-6e57ee5f-e966-44a3-ae12-6d5eaca97913.gif)

---

## 🔑 학습 키워드

- CollectionView
- FlowLayout
- UIRefreshControl
- UIActivityIndicatorView
- 이미지 비동기 로딩
- Custom Cell
- 무한 스크롤
- Json Decoder
- URLSession cancel

---

## 📖 학습 내용

### CollectionView에서 네트워크에서 받아온 이미지 보여주기

> tableView나 CollectionView에서 url을 통해서 이미지를 요청하고 받아올 떄는 반드시 유의해야하는 사항이 있습니다.
> 

다음 예제 화면과 코드를 봅시다.

```swift
func collectionView(_ collectionView: UICollectionView, 
										cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
	...
	URLSession.shared.dataTask(with: URL(string: item.largeImageURL)!) { data, _, _ in
		if let data = data {
			let image = UIImage(data: data)
			DispatchQueue.main.async {
				cell.photo.image = image
			}
		}			
	...
}

```
![이미지바로로딩](https://user-images.githubusercontent.com/35272802/136804957-ac1af165-1855-49f7-ac94-4149d274f57e.gif)


`cellForItemAt` 에서 이미지를 url로 불러오고 불러온 이미지를 바로 cell 넣습니다. 그런데 앱을 실행 시켜보면 위와 같이 이미지가 계속 바뀌는 현상을 볼 수 있습니다. 왜그럴까요?

> 기본적으로 ios는 cell을 재사용하는데 이미지가 로딩이 완료되는 시점이 다 다르기 때문입니다.
> 

이미지는 아직 로딩 중인데 사용자가 화면을 스크롤해서 이동을 하면 또 다른 `cellForItemAt` 함수가 호출이 됩니다. 그러면 또 이미지를 불러오고 먼저 불러온 이미지가 재사용 된 셀에 보이고 또 다른 이미지가 보이는 현상이 발생합니다.(위 예제는 일부러 고해상도의 이미지를 사용했습니다. 저용량 이미지를 사용하면 아무 문제가 없는 것 처럼 보일 수 있습니다)

그러면 이러한 문제를 어떻게 해결할 수 있을까요? 

가장 먼저 떠오르는 방법은 cache를 사용하는 것입니다. 이미 한번 네트워크에서 받아온 이미지는 또 다시 받을 필요는 없을 것 같습니다. 처음 받아온 이미지와 해당 cell의 위치를 cache에 저장하고 다시 해당 위치에 `cellForItemAt` 이 호출 되었을 때 cache에 있는 이미지를 보여주면 됩니다.

하지만 이것은 근본적인 해결 방식은 아닌 것 같습니다. 이 문제를 해결하기 위한 기록들은 고민한점(링크)에 기록하였습니다.

### CollectionView Custom Cell 등록하기

스토리보드에서 CollectionView 커스텀 cell을 구현할 때는 이미 주어진 cell에서 구현할 수도 있지만 xib파일을 따로 만들어서 구현할 수 있다. 그럴려면 뷰컨에서 nib를 register 해줘야 한다.

```swift
collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil),
												forCellWithReuseIdentifier: "listCollectionViewCell")
```

### CollectionView Prefetching

ios10에 추가 된 기술로 `willDisplay` 함수가 호출 되기 한참 전에 미리 호출이 되어서 cell에서 벌어지는 무거운 작업들을 비동기적으로 수행한다. 

```swift
collectionView.prefetchDataSource = self

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
	}
}
```

- UICollectionViewDataSourcePrefetching 프로토콜을 채택해야 한다.
- 반드시 `prefetchItemsAt` 함수를 구현해야 한다.
- `prefetchItemsAt` 함수 안에서 `indexPath` 배열에 미리 작업해야할 indexPath들이 있다(천천히 스크롤 하면 하나의 indexPath 만 들어있다)

### UILabel 취소선 구현하기

```swift
// 취소선 그리기
let attributeString = NSMutableAttributedString(string: label.text!)
attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                             value: NSUnderlineStyle.single.rawValue,
                             range: NSRange(location: 0,
                                            length: label.text?.count ?? 0))
label.attributedText = attributeString

// 취소선 지우기
let attributeString = NSMutableAttributedString(string: label.text!)
attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle,
                                range: NSRange(location: 0,
                                               length: label.text?.count ?? 0))
label.attributedText = attributeString
```

### CALayer를 사용해서 CollectionView Cell의 구분선 그리기

```swift
extension CALayer {
    func drawBottomBorder() {
        let border = CALayer()
        border.frame = CGRect.init(x: 0,
                                   y: frame.height - 1.0,
                                   width: frame.width,
                                   height: 1.0)
        border.backgroundColor = UIColor.gray.cgColor
        self.addSublayer(border)
    }
}
```

- CA → CoreAnimation (UIkit의 바로 상단 레벨, 더 상단은 Core Graphics)
- UIView는 한개의 루트 CALayer를 가지고 있고 여러개의 sublayer를 둘 수 있다(UIView 처럼)

## 🤔 고민한 점

### 이미지 로딩 `Data(contentsOf:)` VS `URLSession`

`Data(ContentOf:)`

- `UIImage` 의 생성자를 사용해서 이미지를 불러올 수 있다.

```swift
let url = URL(string: urlString)!
let data = try? Data(contentsOf: url)
imageView.image = UIImage(data: data!)
```

`URLSessionDataTask`

```swift
URLSession.shared.dataTask(with: imageURL) { data, response, error in 
	guard let data = data else { return }
	let image = UIImage(data: data)
	DispatchQueue.main.async { 
		imageView.image = image
	}	
}.resume()
```

> url을 사용해서 이미지를 불러올 수 있는 방법은 위와 같이 두가지 이다. 어떤 것을 사용할까?
> 

결론적 `URLSession` 을 사용하라고 애플은 권장한다. 이유는 다음과 같다.

NSData에 `init(contentsOf:)` [공식문서](https://developer.apple.com/documentation/foundation/nsdata/1413892-init) 을 보자! 

```
Important
Don't use this synchronous initializer to request network-based URLs. 
For network-based URLs, this method can block the current thread for 
tens of seconds on a slow network, resulting in a poor user experience, 
and in iOS, may cause your app to be terminated.
Instead, for non-file URLs, consider using the 
dataTask(with:completionHandler:) method of the URLSession class. 
```

당연하게 해당 initializer는 동기로 작동을 한다. 이것을 여러번 쓰게 돠면 메인쓰레드가 블락이 될 수 있는 상황이 생긴다. 그래서 내부적으로 비동기로 작동하는 `URLSessionDataTask` 를 사용하라고 권장하고 있다.

그런데 한가지 드는 의문점이 있다.

> 그러면 글로벌 큐를 사용해서 비동기적으로 처리해주면 안되나?
> 

```swift
DispatchQueue.global().async { [weak self] in
	if let data = try? Data(contentsOf: url) {
		if let image = UIImage(data: data) {
			DispatchQueue.main.async {
				self?.image = image
			}
		}
	}
}
```

다음과 같은 예제를 자주 볼 수 있다.

그런데 왜 애플은 `URLSession` 을 추천했을까? 

일단 `URLSession` 의 기능이 휠씬 많다. 설정을 다양하게 줄 수 있고 실패 했을 때 처리도 다양하게 해줄 수 있다. 그리고 요청을 취소하는 것도 가능하다.

나중을 생각하더라고 코드를 추가,수정을 하거나 리펙토링을 하더라도 `URLSession` 을 사용하는게 용이해 보인다.

> 추가
> 
- ios15에서는 `AsyncImage` 가 추가된다고 합니다!

### Cache를 사용하지 않고 CollectionView에서 이미지 로딩 구현하기

첫번째 시도 - `cellForItemAt` 호출 시점의 IndexPath와 이미지 다운이 완료된 시점의 IndexPath를 비교해서 구현

```swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
	guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell else {
		return UICollectionViewCell()
	}
	let model = models[indexPath.item]
	URLSession.shared.dataTask(with: URL(string: model.fullURL)!) { data, _, _ in
		if let data = data {
			let image = UIImage(data: data)
			DispatchQueue.main.async {
				if let cellIndex = **collectionView.indexPath(for: cell)**,
							 cellIndex == indexPath {
					cell.photo.image = image
				}
			}
		}
	}
}
```

- 셀이 계속 재사용 됨으로 스크롤을 빠르게 하면 동일한 셀에 여러개의 이미지 요청이 생김.
- `collectionView.indexPath(for: cell)` 은 현재 화면에 보이는 셀의 `indexPath` 를 반환함.
    - 만약 5개를 셀을 재사용한다고 가정해 보자
    - 데이터의 갯수는 30개라고 했을 때 위에서 맨 아래로 스크롤을 하고 5번쨰 셀에 어떤 이미지 요청이 있는지를 보자.
    - 그러면 5, 10, 15, 20, 25, 30번째 이미지를 요청하고 그 셀에 이미지를 넣으려고 할 것이다.
    - 하지만 우리는 지금 30번째에 있기 때문에 30번째 이미지 만을 보여줘야 한다.
    - 그래서 `cellIndex == indexPath` 을 비교해서 같은 indexPath만 보여지게 한다.
        - 다른 이미지들은 다운은 받아지지만 이미지뷰에는 보여지지 않는다.

> 이 방법은 TableView와 ios10 이전의 collecionView에서는 잘 동작을 한다. 하지만 지금 collectionView에서는 문제가 있다.
> 

![collectionView_문제](https://user-images.githubusercontent.com/35272802/136805590-70db1f1d-ab02-48c6-b659-e600561ed313.gif)


collectionView에서 아주 살짝 스크롤를 내렸는데 3~4의 `cellForItemAt` 이 미리 호출되어 버렸다.

이렇게 되면 `collectionView.indexPath(for: cell)` 을 호출했을 때 찾고자 하는 cell이 화면에 없게되고 그러면 nil을 리턴하게 된다.(ios15부터는 조금 수정되었다고 한다) 미리 호출한 셀의 이미지는 나타나지 않는다.

tableView와 달리 collectionView는 한 행에 여러개의 cell를 보여줄 수 있기 때문에 미리 cell을 만들어놔야 부드럽게 스크롤이 되어 사용자 경험을 좋게 할 수 있다. (ios10에 collectionView prefetching 기술이 도입 되었다)

`collectionView.isPrefetchingEnabled = false` 를 설정해서 prefetching 기능 비활성화 시키는 방법도 있지만 애플이 의도한것은 아닐 것 같다.

다른 한가지 방법을 생각볼 수 있는 것은.. 이미지 요청을 하는 `URLSessionDataTask` 을 재사용 할때 dataTask를 취소 시키는 것이다. 이렇게 구현하려면 이미지를 요청하고 cell안에 이미지뷰에 넣으려면 `cellForItemAt`보다 Cell 객체 안에서 수행하고 `prepareForReuse` 함수를 사용하는 것이 좋을 것 같다.

먼저 Cell 클래스 안에서 이미지를 불러오는 로직을 구현해 보자! 그리고 `prepareForReuse` 함수에서 dataTask를 `cancel()` 을 해보자!

```swift
class CollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var photo: UIImageView!
	var dataTask: URLSessionDataTask?

	override func prepareForReuse() {
		super.prepareForReuse()
		photo.image = nil
		dataTask?.cancel()
	}

	func loadImage(url: String) {
		dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
			if let data = data {
				let image = UIImage(data: data)
				DispatchQueue.main.async { [weak self] in 
					self?.photo.image = image
				}
			}
		}
		dataTask?.resume()
	}
}
```

![prepareforreuse_cancel](https://user-images.githubusercontent.com/35272802/136805614-d0d01b8f-7de1-4fbb-96f2-1bf040a86366.gif)


`cancel()` 을 했는데 취소가 되지 않는다..(위의 경우에는 `prepareForReuse` 가 잘 호출되지만 빠르게 스크롤하면 호출이 안되는 경우도 있었다.)

새로운 이미지 요청을 하기 전에 이전에 있던 요청을 취소해도 계속 취소가 되지 않았다.

```swift
func loadImage(url: String) {
	dataTask?.cancel()
	...
	...
}
```

검색을 해 보아도 왜 dataTask가 취소가 되지 않는지는 명확하게 나온 것이 없어서 맨 처음 사용했던 `indexPath` 를 비교하는 방법을 cell안에서 사용해 보기로 했다.

```swift
class CollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var photo: UIImageView!
	var dataTask: URLSessionDataTask?
	var indexPath: IndexPath?

	override func prepareForReuse() {
		super.prepareForReuse()
		photo.image = nil
		dataTask?.cancel()
	}

	func loadImage(url: String, indexPath: IndexPath) {
		dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
			if let data = data {
				let image = UIImage(data: data)
				DispatchQueue.main.async { [weak self] in 
					if self?.indexPath == indexPath {
						self?.photo.image = image
					}
				}
			}
		}
		dataTask?.resume()
		self.indexPath = indexPath
	}
}
```

- cell이 indexPath를 가지고 있고 이미지 요청을 하고 난 바로 직후 매개변수로 넘겨 받은 indexPath를 가지고 있는다.
- 그리고 메인쓰레드에서는 이미지 요청이 끝난 시점에서 현재 cell의 indexPath와 요청한 indexPath를 비교한다.
- 스크롤 빨리 하면 한개의 cell의 여러 요청이 오고 현재 cell과 같은 위치의 요청만 이미지를 보여주면 된다.

![cell안에서_indexpath비교](https://user-images.githubusercontent.com/35272802/136805647-77c6e3b4-fbfa-479f-8242-28b85993f16c.gif)


아무래도 cache를 사용하지 않고 구현하다 보니 어려움 있었다. 물론 테스트를 위해서 이미지 용량을 크게 했다. 보통은 리스트 뷰에는 썸네일 크기의 이미지를 보여줘 크게 처리 문제 될일이 없지만 이번 기회에 어떻게 collectionView가 동작하는지도 알아보고 좋은 경험이었다.

### 어떻게 페이지 무한 스크롤을 구현할 것인가?

> collectionView prefetch 함수에 구현
> 
- prefetch 함수 안에서 indexPath가 상품 배열에 마지막일 때 마음 페이지(20개)를 미리 불러옴.
- 문제점 - 아주 빠르게 스크롤 할 경우 prefetch 함수가 호출이 안되는 경우가 있음. → 이럴 때는 스크롤을 다시 위로 올렸다가 내리면 호출이 되면서 로딩이 됨.
    
![prefatch_scroll_문제](https://user-images.githubusercontent.com/35272802/136805163-ed1b627a-9d99-4924-86dc-50db74cc7932.gif)
    

> 빠른 스크롤 대비해서 `willDisplay` 함수에도 로딩 구현
> 
- 상품이 배열의 마지막 `willDisplay` 함수를 호출 했을 때도 서버api에 요청을 하게 구현
- 중복 호출 방지로 여러번 호출 되지 않음.

### 무한 스크롤 구현 시 어떻게 중복 호출을 방지할 수 있을까?

뷰컨의 `isFetching` 프로퍼티를 두어서 중복 호출 되지 않게 방지

---

## 🚧 트러블 슈팅

### Xcode에서 프로젝트 스킴이 안나오는 현상

[https://jamesu.dev/posts/2021/03/02/til-29-how-to-fix-no-scheme-bug-in-xcode/](https://jamesu.dev/posts/2021/03/02/til-29-how-to-fix-no-scheme-bug-in-xcode/)

xcodeproj/xcuserdata 삭제를 하고 xcode 재부팅하니 해결!!!!!

### refreshControl.endRefreshing() 호출시 스크롤이 끊기는 현상
![스크롤_끊김](https://user-images.githubusercontent.com/35272802/136805142-39f12ed1-c920-439b-b4b4-7f8ead015221.gif)


> 원인
> 
- 정확한 이유는 모르겠다..
- 검색을 해보니 `isRefreshing` 이 true 일때만 호출하거나 딜레이를 시켜서 호출하라는 예시가 많이 나와있다.

> 해결 방법
> 
- 서버 api에서 fetch 하는 함수에 클로저를 넣어줘 상황에 따라 fetch가 끝나는 작업을 매개변수로 넘겨주었다.

```swift
func fetchgoodsData(handler: (() -> Void)?)

// 아래로 스크롤 후
fetchgoodsData {
	self.refreshControl.endRefreshing()
}

// 인피니티 스크롤 시 -> fetch 후 아무 작업도 안함.
fetchgoodsData(handler: nil)
```

### 아래로 스크롤시 `cellForItemAt` 에서 Index out of range 에러가 발생하는 문제

> 원인
> 
- 스크롤을 시작하자마자 상품 정보가 담겨 있는 배열을 모두 비우고 다시 스크롤이 아래로 내려가면 `cellForItemAt` 함수가 호출되면서(리스트뷰는 8.9번째가 호출됨) 상품 정보 배열에 indexPath로 접근을 하지만 이미 배열에는 아무것도 없어서 발생하는 문제

> 해결방법
> 
- `cellForItemAt` 에서 배열이 비어 있을 때는 접근하기 못하게 막음.

```swift
func collectionView(_ collectionView: UICollectionView,
                    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
	...
	if !goods.isEmpty {
		cell.configure(with: goods[indexPath.item])
	}
	...
}
```

> 수정
> 
- 상품 배열에 didset 안에 collectionView를 변경하는 코드를 삽입
- 배열이 다 지워질때 `reloadData()` 를 하고 그 다음 다시 새로운 데이터가 들어왔을때 `insertItems()` 함수를 호출해서 위 해결 방법에서 작성한 코드가 없어도 됨(`if !goods.isEmpty` 삭제)
