#!/bin/sh

## README
# /!\ Ce script d'installation est conçu pour mon usage. Ne le lancez pas sans vérifier chaque commande ! /!\

## La base : Homebrew et les lignes de commande
if test ! $(which brew)
then
	echo 'Installation de Homebrew'
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Vérifier que tout est bien à jour
brew update
 
## Utilitaires pour les autres apps : Cask et mas (Mac App Store)
echo 'Installation de mas, pour installer les apps du Mac App Store.'
brew install mas
echo "Saisir le mail du compte iTunes :" 
read COMPTE
echo "Saisir le mot de passe du compte : $COMPTE"
read -s PASSWORD
mas signin $COMPTE "$PASSWORD"

# Installation d'apps avec mas (source : https://github.com/argon/mas/issues/41#issuecomment-245846651)
function install () {
	# Check if the App is already installed
	mas list | grep -i "$1" > /dev/null

	if [ "$?" == 0 ]; then
		echo "==> $1 est déjà installée"
	else
		echo "==> Installation de $1..."
		mas search "$1" | { read app_ident app_name ; mas install $app_ident ; }
	fi
}

echo 'Installation de Cask, pour installer les autres apps.'
brew tap caskroom/cask

## Installations des logiciels
echo 'Installation des outils en ligne de commande.'
brew install wget git node 
gem install sass
brew install git-flow-avh 
npm install -g bower

## Installation de ruby environnement 
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

## configuration
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
. ~/.bash_profile

## afficher toutes les versions de ruby disponible
rbenv install -l

## installation ruby 2.4.0
echo 'Installation de ruby'
rbenv install 2.4.0
rbenv local 2.4.0

##installation de rails attention aux versions 4.7.x et 5.x et de bundler
echo 'Installation de bundler'
gem install bundler
echo 'Installation de rails'
gem install rails 

## installation de rbenv variables à utiliser avec .rbenv-vars dans vote projet
git clone https://github.com/rbenv/rbenv-vars.git $(rbenv root)/plugins/rbenv-vars

## Installation de PHP 7.1
echo 'Installation de PHP 7.1'
brew update
brew upgrade

brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php

brew unlink php70
brew install php71

## Installation de Synfony
echo 'Installation de Synfony'
sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony

## Installation de Ionic et de Cordova

npm install -g ionic cordova

echo 'Installation des apps : utilitaires.'
brew cask install alfred  appcleaner 

echo 'Installation des apps : bureautique.'
install "Pages"
install "Keynote"
install "Numbers"

echo 'Installation des apps : développement.'
brew cask install github-desktop atom wordpresscom gitkraken 
install "Xcode"

echo 'Installation des apps : communication.'
install « Dashlane »
brew cask install google-chrome firefox transmission



## ************************* CONFIGURATION ********************************
echo "Configuration de quelques paramètres par défaut…"

## FINDER


# Finder : affichage de la barre latérale / affichage par défaut en mode liste / affichage chemin accès / extensions toujours affichées
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string “Nlsv”
defaults write com.apple.finder ShowPathbar -bool true
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Recherche dans le dossier en cours par défaut
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Coup d'œîl : sélection de texte
defaults write com.apple.finder QLEnableTextSelection -bool true

# Pas de création de fichiers .DS_STORE
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true


## RÉGLAGES DOCK
# Agrandissement actif
defaults write com.apple.dock magnification -bool true
# Taille maximale pour l'agrandissement
defaults write com.apple.dock largesize -float 128

# Mot de passe demandé immédiatement quand l'économiseur d'écran s'active
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0


## APPS

# Safari : menu développeur / URL en bas à gauche / URL complète en haut / Do Not Track / affichage barre favoris
defaults write com.apple.safari IncludeDevelopMenu -int 1
defaults write com.apple.safari ShowOverlayStatusBar -int 1
defaults write com.apple.safari ShowFullURLInSmartSearchField -int 1
defaults write com.apple.safari SendDoNotTrackHTTPHeader -int 1
defaults write com.apple.Safari ShowFavoritesBar -bool true

# Photos : pas d'affichage pour les iPhone
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

# TextEdit : .txt par défaut
defaults write com.apple.TextEdit RichText -int 0

# Raccourci pour exporter 
sudo defaults write -g NSUserKeyEquivalents '{"Export…"="@$e";"Exporter…"="@$e";}'

## ************ Fin de l'installation *********
echo "Finder et Dock relancés… redémarrage nécessaire pour terminer."
killall Dock
killall Finder

echo "Derniers nettoyages…"
brew cleanup
rm -f -r /Library/Caches/Homebrew/*

echo "ET VOILÀ !"
