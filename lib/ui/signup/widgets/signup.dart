import 'package:flutter/material.dart';
import 'package:sporty/ui/core/shared/social-button.dart';
import 'package:sporty/ui/core/shared/text-divider.dart';

import '../../../utils/constants/size.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              Text('Inscription', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: Sizes.spaceItems),

              Form(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: 'Prénom',
                              prefixIcon: Icon(Icons.person)
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: Sizes.spaceInputs,
                        ),
                        Expanded(
                          child: TextFormField(
                            expands: false,
                            decoration: const InputDecoration(
                                labelText: 'Nom',
                                prefixIcon: Icon(Icons.person)
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Sizes.spaceInputs,
                    ),
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: 'Nom d\'utilisateur',
                        prefixIcon: Icon(Icons.person)
                      ),
                    ),
                    const SizedBox(
                      height: Sizes.spaceInputs,
                    ),
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: 'Adresse email',
                        prefixIcon: Icon(Icons.email)
                      ),
                    ),
                    const SizedBox(
                      height: Sizes.spaceInputs,
                    ),
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.remove_red_eye)
                      ),
                    ),
                    const SizedBox(
                      height: Sizes.spaceInputs,
                    ),
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value){}),
                        Expanded(
                          child: Text.rich(TextSpan(
                            children: [
                              TextSpan(
                                text: 'J\'accepte la '
                              ),
                              TextSpan(
                                text: 'Politique de confidentialié',
                                style: Theme.of(context).textTheme.bodyMedium!.apply(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' et '
                              ),
                              TextSpan(
                                text: 'Les conditions générales d\'utilisation',
                                style: Theme.of(context).textTheme.bodyMedium!.apply(
                                  decoration: TextDecoration.underline
                                )
                              )
                            ]
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Sizes.spaceSections,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){},
                        child: Text('S\'inscrire')
                      ),
                    )
                  ],
                ),
              ),

              TextDivider(dividerText: 'Ou inscrivez vous avec'),
              SizedBox(height: Sizes.spaceSections),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(socialIcon: 'public/img/google_logo.svg'),
                  SizedBox(width: Sizes.spaceItems),
                  SocialButton(socialIcon: 'public/img/facebook_icon.svg')
                ],
              )
            ],
          )
        ),
      ),
    );
  }
  
}