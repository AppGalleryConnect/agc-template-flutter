/// 协议数据类
/// 存储各种用户协议和隐私政策的HTML内容
class ProtocolData {
  ProtocolData._();

  /// 用户协议HTML内容
  static const String userProtocol = '''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>用户协议</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            background-color: #F5F6FA;
            color: #1F2937;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.6;
        }
        
        header {
            background-color: transparent;
            position: sticky;
            top: 0;
            z-index: 10;
            transition: all 0.3s;
        }
        
        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-title {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        h1 {
            font-size: 40px;
            font-weight: 700;
            color: #1F2937;
        }
        
        main {
            flex-grow: 1;
            max-width: 1200px;
            margin: 0 auto;
            padding: 16px 16px 32px;
            width: 100%;
        }
        
        .content-card {
            max-width: 896px;
            margin: 0 auto;
            background-color: #FFFFFF;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s;
        }
        
        .content-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .content-padding {
            padding: 24px;
        }
        
        @media (min-width: 768px) {
            .content-padding {
                padding: 32px;
            }
        }
        
        .intro-section {
            margin-bottom: 32px;
        }
        
        h2 {
            font-size: 32px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 16px;
            text-wrap: balance;
        }
        
        .intro-text {
            color: #4B5563;
            font-size: 16px;
        }
        
        .sections-container {
            display: flex;
            flex-direction: column;
            gap: 32px;
        }
        
        section {
            scroll-margin-top: 80px;
        }
        
        h3 {
            font-size: 22px;
            font-weight: 700;
            color: #1F2937;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
        }
        
        .section-number {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: #3B82F6;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            font-size: 18px;
            font-weight: 700;
            color: #000000;
        }
        
        p {
            color: #4B5563;
            line-height: 1.75;
            margin-bottom: 16px;
            font-size: 16px;
        }
        
        p:last-child {
            margin-bottom: 0;
        }
    </style>
</head>
<body>
    <main>
        <div class="content-card">
            <div class="content-padding">
                <div class="intro-section">
                    <h1 style="text-align: center; margin-bottom: 24px;">用户协议</h1>
                    <h2 style="text-align: center;">服务条款</h2>
                    <p class="intro-text">请仔细阅读以下条款，使用我们的服务即表示您同意这些条款。</p>
                </div>

                <div class="sections-container">
                    <section id="section1">
                        <h3>
                            <span class="section-number">1</span>
                            服务概述
                        </h3>
                        <p>
                            我们通过网站及移动应用（以下统称"服务"）为用户提供信息、工具和服务。这些服务可能包括但不限于内容浏览、社交互动、交易服务和个性化推荐。
                        </p>
                        <p>
                            我们保留随时修改或停止服务的权利，而无需事先通知您。我们不会对您或任何第三方因服务的修改、暂停或终止而遭受的任何损失承担责任。
                        </p>
                    </section>

                    <section id="section2">
                        <h3>
                            <span class="section-number">2</span>
                            用户账号
                        </h3>
                        <p>
                            使用我们的服务可能需要您创建一个账号。您同意提供准确、完整和最新的个人信息，并维护和及时更新这些信息。
                        </p>
                        <p>
                            您对您账号下发生的所有活动负责。如果您发现任何未经授权使用您账号的情况，您应立即通知我们。您不得将您的账号转让给任何第三方。
                        </p>
                    </section>

                    <section id="section3">
                        <h3>
                            <span class="section-number">3</span>
                            隐私政策
                        </h3>
                        <p>
                            我们重视您的隐私，并根据我们的隐私政策收集、使用和保护您的个人信息。使用我们的服务即表示您同意我们按照该隐私政策处理您的信息。
                        </p>
                        <p>
                            我们可能会更新我们的隐私政策，建议您定期查看。继续使用我们的服务即表示您同意这些更新。
                        </p>
                    </section>

                    <section id="section4">
                        <h3>
                            <span class="section-number">4</span>
                            内容使用
                        </h3>
                        <p>
                            我们服务中提供的内容（包括但不限于文本、图形、图像、视频、音频）受版权、商标和其他知识产权法律的保护。
                        </p>
                        <p>
                            您可以为个人非商业用途查看和使用这些内容，但未经我们明确书面许可，不得复制、修改、分发、传输或创建衍生作品。
                        </p>
                    </section>

                    <section id="section5">
                        <h3>
                            <span class="section-number">5</span>
                            用户行为
                        </h3>
                        <p>
                            您同意不利用我们的服务从事非法活动，或促进、鼓励任何非法活动。您不得干扰或破坏服务的正常运行，或试图访问未授权的系统或数据。
                        </p>
                        <p>
                            您不得在服务中发布或传播垃圾邮件、病毒、恶意软件或任何其他有害内容。您不得收集或存储其他用户的个人信息。
                        </p>
                    </section>

                    <section id="section6">
                        <h3>
                            <span class="section-number">6</span>
                            免责声明
                        </h3>
                        <p>
                            我们的服务按"原样"提供，不附带任何形式的明示或暗示保证，包括但不限于适销性、特定用途适用性和不侵权的保证。
                        </p>
                        <p>
                            在适用法律允许的最大范围内，我们不对因使用或无法使用服务而导致的任何直接、间接、偶然、特殊、惩罚性或后果性损害承担责任。
                        </p>
                    </section>

                    <section id="section7">
                        <h3>
                            <span class="section-number">7</span>
                            法律适用与争议解决
                        </h3>
                        <p>
                            本协议受[具体司法管辖区]法律管辖。因本协议引起的或与本协议有关的任何争议，应通过双方友好协商解决；协商不成的，任何一方均有权将争议提交[具体仲裁机构或法院]解决。
                        </p>
                        <p>
                            如果本协议的任何条款被认定为无效或不可执行，该条款应被删除或修改，而其余条款应继续有效。
                        </p>
                    </section>

                    <section id="section8">
                        <h3>
                            <span class="section-number">8</span>
                            协议更新
                        </h3>
                        <p>
                            我们可能会不时更新本服务条款。当我们进行重大更改时，我们将通过在我们的网站上发布新的服务条款通知您，并且在某些情况下，我们可能会通过电子邮件或其他通信方式通知您。
                        </p>
                        <p>
                            您继续使用我们的服务即表示您接受这些更新。我们鼓励您定期查看本服务条款。
                        </p>
                    </section>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
''';

  /// 隐私政策HTML内容
  static const String privacyProtocol = '''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>隐私政策</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            background-color: #F5F6FA;
            color: #1F2937;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.6;
        }
        
        main {
            flex-grow: 1;
            max-width: 1200px;
            margin: 0 auto;
            padding: 16px 16px 32px;
            width: 100%;
        }
        
        .content-card {
            max-width: 896px;
            margin: 0 auto;
            background-color: #FFFFFF;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s;
        }
        
        .content-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .content-padding {
            padding: 24px;
        }
        
        @media (min-width: 768px) {
            .content-padding {
                padding: 32px;
            }
        }
        
        .intro-section {
            margin-bottom: 32px;
        }
        
        h2 {
            font-size: 28px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 16px;
            text-wrap: balance;
        }
        
        .intro-text {
            color: #4B5563;
            font-size: 16px;
        }
        
        .sections-container {
            display: flex;
            flex-direction: column;
            gap: 32px;
        }
        
        section {
            scroll-margin-top: 80px;
        }
        
        h3 {
            font-size: 22px;
            font-weight: 700;
            color: #1F2937;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
        }
        
        .section-number {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: #3B82F6;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            font-size: 18px;
            font-weight: 700;
            color: #000000;
        }
        
        p {
            color: #4B5563;
            line-height: 1.75;
            margin-bottom: 16px;
            font-size: 16px;
        }
        
        p:last-child {
            margin-bottom: 0;
        }
    </style>
</head>
<body>
    <main>
        <div class="content-card">
            <div class="content-padding">
                <div class="intro-section">
                    <h2 style="text-align: center; margin-bottom: 24px;">用户协议</h2>
                    <h2 style="text-align: center;">隐私政策</h2>
                    <p class="intro-text">我们非常重视您的隐私保护。本隐私政策说明了我们如何收集、使用、披露和保护您的个人信息。</p>
                </div>

                <div class="sections-container">
                    <section id="section1">
                        <h3>
                            <span class="section-number">1</span>
                            信息收集
                        </h3>
                        <p>
                            我们收集您在使用我们服务时提供的信息，包括但不限于您的姓名、电子邮件地址、电话号码、设备信息和使用数据。
                        </p>
                        <p>
                            我们还可能自动收集某些信息，如您的IP地址、浏览器类型、操作系统、访问时间和引荐页面。
                        </p>
                    </section>

                    <section id="section2">
                        <h3>
                            <span class="section-number">2</span>
                            信息使用
                        </h3>
                        <p>
                            我们使用收集的信息来提供、维护和改进我们的服务，处理交易，发送通知，并提供客户支持。
                        </p>
                        <p>
                            我们还可能使用您的信息来个性化您的体验，进行数据分析，并防止欺诈和滥用行为。
                        </p>
                    </section>

                    <section id="section3">
                        <h3>
                            <span class="section-number">3</span>
                            信息共享
                        </h3>
                        <p>
                            我们不会出售您的个人信息。我们可能与服务提供商、业务合作伙伴和法律要求的情况下共享您的信息。
                        </p>
                        <p>
                            在共享信息时，我们会确保接收方遵守适当的隐私和安全标准。
                        </p>
                    </section>

                    <section id="section4">
                        <h3>
                            <span class="section-number">4</span>
                            数据安全
                        </h3>
                        <p>
                            我们采取合理的技术和组织措施来保护您的个人信息免受未经授权的访问、使用、披露、更改或破坏。
                        </p>
                        <p>
                            然而，没有任何互联网传输或电子存储方法是100%安全的，我们无法保证绝对的安全性。
                        </p>
                    </section>

                    <section id="section5">
                        <h3>
                            <span class="section-number">5</span>
                            您的权利
                        </h3>
                        <p>
                            您有权访问、更正、删除或限制处理您的个人信息。您还可以反对处理或要求数据可携带性。
                        </p>
                        <p>
                            要行使这些权利，请通过本隐私政策中提供的联系方式与我们联系。
                        </p>
                    </section>

                    <section id="section6">
                        <h3>
                            <span class="section-number">6</span>
                            Cookie和跟踪技术
                        </h3>
                        <p>
                            我们使用Cookie和类似的跟踪技术来收集和使用有关您使用我们服务的信息。
                        </p>
                        <p>
                            您可以通过浏览器设置控制Cookie的使用，但这可能会影响某些功能的可用性。
                        </p>
                    </section>

                    <section id="section7">
                        <h3>
                            <span class="section-number">7</span>
                            儿童隐私
                        </h3>
                        <p>
                            我们的服务不面向13岁以下的儿童。我们不会故意收集13岁以下儿童的个人信息。
                        </p>
                        <p>
                            如果我们发现我们收集了13岁以下儿童的个人信息，我们将采取步骤删除该信息。
                        </p>
                    </section>

                    <section id="section8">
                        <h3>
                            <span class="section-number">8</span>
                            隐私政策更新
                        </h3>
                        <p>
                            我们可能会不时更新本隐私政策。我们将通过在我们的网站上发布新的隐私政策来通知您任何更改。
                        </p>
                        <p>
                            建议您定期查看本隐私政策以了解我们如何保护您的信息。
                        </p>
                    </section>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
''';

  /// 第三方信息共享清单HTML内容
  static const String thirdPartyInfo = '''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>第三方信息共享清单</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            background-color: #F5F6FA;
            color: #1F2937;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.6;
        }
        
        main {
            flex-grow: 1;
            max-width: 1200px;
            margin: 0 auto;
            padding: 16px 16px 32px;
            width: 100%;
        }
        
        .content-card {
            max-width: 896px;
            margin: 0 auto;
            background-color: #FFFFFF;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s;
        }
        
        .content-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .content-padding {
            padding: 24px;
        }
        
        @media (min-width: 768px) {
            .content-padding {
                padding: 32px;
            }
        }
        
        .intro-section {
            margin-bottom: 32px;
        }
        
        h2 {
            font-size: clamp(24px, 3vw, 40px);
            font-weight: 700;
            color: #111827;
            margin-bottom: 16px;
            text-wrap: balance;
        }
        
        .intro-text {
            color: #4B5563;
            font-size: 16px;
        }
        
        .sections-container {
            display: flex;
            flex-direction: column;
            gap: 32px;
        }
        
        section {
            scroll-margin-top: 80px;
        }
        
        h3 {
            font-size: 20px;
            font-weight: 700;
            color: #1F2937;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
        }
        
        .section-number {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: rgba(59, 130, 246, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            font-size: 16px;
            font-weight: 600;
            color: #3B82F6;
        }
        
        p {
            color: #4B5563;
            line-height: 1.75;
            margin-bottom: 16px;
            font-size: 16px;
        }
        
        p:last-child {
            margin-bottom: 0;
        }
        
        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
        }
        
        .info-table th,
        .info-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #E5E7EB;
        }
        
        .info-table th {
            background-color: #F5F6FA;
            font-weight: 600;
            color: #374151;
        }
        
        .info-table td {
            color: #6B7280;
        }
    </style>
</head>
<body>
    <main>
        <div class="content-card">
            <div class="content-padding">
                <div class="intro-section">
                    <h2>第三方信息共享清单</h2>
                    <p class="intro-text">本清单列出了我们可能与之共享您个人信息的第三方服务提供商及共享目的。</p>
                </div>

                <div class="sections-container">
                    <section id="section1">
                        <h3>
                            <span class="section-number">1</span>
                            分析服务提供商
                        </h3>
                        <p>
                            我们使用第三方分析服务来帮助我们了解用户如何使用我们的服务，以便改进用户体验。
                        </p>
                        <table class="info-table">
                            <tr>
                                <th>服务提供商</th>
                                <th>共享信息类型</th>
                                <th>用途</th>
                            </tr>
                            <tr>
                                <td>Google Analytics</td>
                                <td>使用数据、设备信息</td>
                                <td>网站分析和优化</td>
                            </tr>
                        </table>
                    </section>

                    <section id="section2">
                        <h3>
                            <span class="section-number">2</span>
                            云服务提供商
                        </h3>
                        <p>
                            我们使用云服务提供商来存储和处理数据，确保服务的可用性和性能。
                        </p>
                        <table class="info-table">
                            <tr>
                                <th>服务提供商</th>
                                <th>共享信息类型</th>
                                <th>用途</th>
                            </tr>
                            <tr>
                                <td>阿里云</td>
                                <td>用户数据、应用数据</td>
                                <td>数据存储和处理</td>
                            </tr>
                        </table>
                    </section>

                    <section id="section3">
                        <h3>
                            <span class="section-number">3</span>
                            支付服务提供商
                        </h3>
                        <p>
                            当您进行交易时，我们会与支付服务提供商共享必要的信息以处理您的支付。
                        </p>
                        <table class="info-table">
                            <tr>
                                <th>服务提供商</th>
                                <th>共享信息类型</th>
                                <th>用途</th>
                            </tr>
                            <tr>
                                <td>支付宝</td>
                                <td>交易信息、联系方式</td>
                                <td>处理支付交易</td>
                            </tr>
                            <tr>
                                <td>微信支付</td>
                                <td>交易信息、联系方式</td>
                                <td>处理支付交易</td>
                            </tr>
                        </table>
                    </section>

                    <section id="section4">
                        <h3>
                            <span class="section-number">4</span>
                            广告合作伙伴
                        </h3>
                        <p>
                            我们可能与广告合作伙伴共享某些信息，以向您展示更相关的广告内容。
                        </p>
                        <p>
                            您可以通过设置选择退出个性化广告。
                        </p>
                    </section>

                    <section id="section5">
                        <h3>
                            <span class="section-number">5</span>
                            法律要求
                        </h3>
                        <p>
                            在法律要求的情况下，我们可能需要向政府机构、执法部门或其他第三方披露您的信息。
                        </p>
                        <p>
                            我们仅在法律明确要求或为保护我们的权利和安全时才会这样做。
                        </p>
                    </section>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
''';

  /// 个人信息收集清单HTML内容
  static const String personalInfoCollection = '''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>个人信息收集清单</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            background-color: #F5F6FA;
            color: #1F2937;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            line-height: 1.6;
        }
        
        main {
            flex-grow: 1;
            max-width: 1200px;
            margin: 0 auto;
            padding: 16px 16px 32px;
            width: 100%;
        }
        
        .content-card {
            max-width: 896px;
            margin: 0 auto;
            background-color: #FFFFFF;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s;
        }
        
        .content-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .content-padding {
            padding: 24px;
        }
        
        @media (min-width: 768px) {
            .content-padding {
                padding: 32px;
            }
        }
        
        .intro-section {
            margin-bottom: 32px;
        }
        
        h2 {
            font-size: clamp(24px, 3vw, 40px);
            font-weight: 700;
            color: #111827;
            margin-bottom: 16px;
            text-wrap: balance;
        }
        
        .intro-text {
            color: #4B5563;
            font-size: 16px;
        }
        
        .sections-container {
            display: flex;
            flex-direction: column;
            gap: 32px;
        }
        
        section {
            scroll-margin-top: 80px;
        }
        
        h3 {
            font-size: 20px;
            font-weight: 700;
            color: #1F2937;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
        }
        
        .section-number {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: rgba(59, 130, 246, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            font-size: 16px;
            font-weight: 600;
            color: #3B82F6;
        }
        
        p {
            color: #4B5563;
            line-height: 1.75;
            margin-bottom: 16px;
            font-size: 16px;
        }
        
        p:last-child {
            margin-bottom: 0;
        }
        
        .info-list {
            list-style: none;
            padding: 0;
        }
        
        .info-list li {
            padding: 12px 0;
            border-bottom: 1px solid #E5E7EB;
            color: #4B5563;
        }
        
        .info-list li:last-child {
            border-bottom: none;
        }
        
        .info-list li strong {
            color: #1F2937;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <main>
        <div class="content-card">
            <div class="content-padding">
                <div class="intro-section">
                    <h2>个人信息收集清单</h2>
                    <p class="intro-text">本清单详细说明了我们收集的个人信息类型、收集方式及使用目的。</p>
                </div>

                <div class="sections-container">
                    <section id="section1">
                        <h3>
                            <span class="section-number">1</span>
                            账户信息
                        </h3>
                        <p>
                            当您注册账户时，我们会收集以下信息：
                        </p>
                        <ul class="info-list">
                            <li><strong>用户名：</strong>用于识别您的账户</li>
                            <li><strong>电子邮件地址：</strong>用于账户验证和通信</li>
                            <li><strong>手机号码：</strong>用于账户安全和身份验证</li>
                            <li><strong>密码：</strong>用于账户安全（加密存储）</li>
                        </ul>
                    </section>

                    <section id="section2">
                        <h3>
                            <span class="section-number">2</span>
                            设备信息
                        </h3>
                        <p>
                            我们自动收集有关您设备的信息：
                        </p>
                        <ul class="info-list">
                            <li><strong>设备型号：</strong>用于优化应用性能</li>
                            <li><strong>操作系统版本：</strong>用于兼容性支持</li>
                            <li><strong>唯一设备标识符：</strong>用于设备识别和安全</li>
                            <li><strong>IP地址：</strong>用于地理位置和安全分析</li>
                        </ul>
                    </section>

                    <section id="section3">
                        <h3>
                            <span class="section-number">3</span>
                            使用数据
                        </h3>
                        <p>
                            我们收集有关您如何使用我们服务的信息：
                        </p>
                        <ul class="info-list">
                            <li><strong>浏览历史：</strong>用于个性化内容推荐</li>
                            <li><strong>搜索查询：</strong>用于改进搜索功能</li>
                            <li><strong>交互数据：</strong>用于分析用户行为</li>
                            <li><strong>访问时间和频率：</strong>用于服务优化</li>
                        </ul>
                    </section>

                    <section id="section4">
                        <h3>
                            <span class="section-number">4</span>
                            位置信息
                        </h3>
                        <p>
                            在您授权的情况下，我们可能收集位置信息：
                        </p>
                        <ul class="info-list">
                            <li><strong>精确位置：</strong>用于基于位置的服务</li>
                            <li><strong>大致位置：</strong>用于地区性内容推荐</li>
                        </ul>
                        <p>
                            您可以随时在设备设置中撤销位置权限。
                        </p>
                    </section>

                    <section id="section5">
                        <h3>
                            <span class="section-number">5</span>
                            通信内容
                        </h3>
                        <p>
                            当您与我们或其他用户通信时：
                        </p>
                        <ul class="info-list">
                            <li><strong>消息内容：</strong>用于提供通信服务</li>
                            <li><strong>联系人信息：</strong>用于社交功能（需授权）</li>
                            <li><strong>客服记录：</strong>用于改进客户服务</li>
                        </ul>
                    </section>

                    <section id="section6">
                        <h3>
                            <span class="section-number">6</span>
                            支付信息
                        </h3>
                        <p>
                            当您进行购买时：
                        </p>
                        <ul class="info-list">
                            <li><strong>支付方式：</strong>用于处理交易</li>
                            <li><strong>交易历史：</strong>用于订单管理和退款</li>
                            <li><strong>账单地址：</strong>用于发票和配送</li>
                        </ul>
                        <p>
                            我们不直接存储完整的支付卡信息，支付处理由第三方支付服务提供商安全处理。
                        </p>
                    </section>

                    <section id="section7">
                        <h3>
                            <span class="section-number">7</span>
                            用户生成内容
                        </h3>
                        <p>
                            您在使用服务时创建或上传的内容：
                        </p>
                        <ul class="info-list">
                            <li><strong>文本内容：</strong>评论、帖子、反馈等</li>
                            <li><strong>图片和视频：</strong>您上传的媒体文件</li>
                            <li><strong>个人资料信息：</strong>头像、简介等</li>
                        </ul>
                    </section>

                    <section id="section8">
                        <h3>
                            <span class="section-number">8</span>
                            数据保留
                        </h3>
                        <p>
                            我们仅在必要的时间内保留您的个人信息，以实现本清单中所述的目的。
                        </p>
                        <p>
                            您可以随时请求删除您的账户和相关数据。某些信息可能因法律要求而需要保留更长时间。
                        </p>
                    </section>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
''';
}
