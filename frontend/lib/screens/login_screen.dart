import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/metamask.dart';

import 'home_page.dart';

class MetaMaskLogin extends StatefulWidget {
  const MetaMaskLogin({Key? key}) : super(key: key);

  @override
  State<MetaMaskLogin> createState() => _MetaMaskLoginState();
}

class _MetaMaskLoginState extends State<MetaMaskLogin> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //Change the provider
      create: (context) => MetaMaskProvider()..init(), //create an instant
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF181818),
          body: Stack(
            children: [
              Center(
                child: Consumer<MetaMaskProvider>(
                  builder: (context, provider, child) {
                    late final String text; //check the state and display it

                    if (provider.isConnected && provider.isInOperatingChain) {
                      text = 'Connected'; //connected
                      // Navigate to the home page
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        ),
                      );
                    } else if (provider.isConnected &&
                        !provider.isInOperatingChain) {
                      text =
                          'Wrong chain. Please connect to ${MetaMaskProvider.operatingChain}'; //wrong chain, what chain it should be connected to
                    } else if (provider.isEnabled) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Click the button...'),
                          const SizedBox(height: 8),
                          CupertinoButton(
                            onPressed: () => context
                                .read<MetaMaskProvider>()
                                .connect(), //call metamask on click
                            color: Colors.white,
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
                                  width: 300,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      text =
                          'Please use a Web3 supported browser.'; //please use web3 supported browser
                    }

                    return ShaderMask(
                      // a little bit of styling for text
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.purple, Colors.blue, Colors.red],
                      ).createShader(bounds),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTicLAkhCzpJeu9OV-4GOO-BOon5aPGsj_wy9ETkR4g-BdAc8U2-TooYoiMcPcmcT48H7Y&usqp=CAU',
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.025),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
