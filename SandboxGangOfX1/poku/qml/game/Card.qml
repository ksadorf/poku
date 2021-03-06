import QtQuick 2.0
import VPlay 2.0
import "../scenes"
import "../game"


EntityBase {
  id: card
  entityType: "card"
  width: 44
  height: 44
  transformOrigin: Item.Bottom
  visible: newParent.visible

  // original card size for zoom
  property int originalWidth: 44
  property int originalHeight: 44
  property bool isSelected: false


  property int level: 0
//  property int points: 50
  property int cardColor: 0
  property int order

  // access the image and text from outside
  //property alias cardImage: cardImage
  //property alias glowImage: glowImage
  //property alias cardButton: cardButton

  // hidden cards show the back side
  // you could also offer an in-app purchase to show the cards of a player for example!
  property bool hidden: !forceShowAllCards

  // to show all cards on the screen and to test multiplayer syncing, set this to true
  // it is useful for testing, thus always enable it for debug builds and non-publish builds
  property bool forceShowAllCards: system.debugBuild && !system.publishBuild


  // used to reparent the cards at runtime
  property var newParent

  function literalRepresentation(){
    return gameScene.deck.levelLit[this.level] + " " + gameScene.deck.cardColorLit[this.cardColor]
  }

  // glow image highlights a valid card
  Image {
    id: glowImage
    anchors.centerIn: parent
    width: parent.width * 1.3
    height: parent.height * 1.3
    source: "../../assets/cards/glow.png"
    visible: parent.isSelected
    smooth: true
  }

  Image {
    id: cardImage
    anchors.fill: parent
    source: "../../assets/cards/back.png"
    smooth: true
    visible: newParent.visible

      // clickable card area
      MouseArea {
        id: cardButton
        anchors.fill: parent
        onClicked: {
          console.log(card.literalRepresentation())
          console.log(entityId)
          gameScene.cardSelected(entityId)
        }
      }
      Text {
          visible: newParent.visible
          id: cardValue
          text: gameScene.deck.levelLit[level]
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
      }
      Rectangle {
        anchors.fill : parent
        color : "white"
        z : -1
      }
  }
  // update the card image
  function updateCardImage(){
    // hidden cards show the back side without effect
    if (hidden){
      cardImage.source = "../../assets/cards/back.png"

    } else {
      var base_image
      switch(cardColor){
      case 0: // blue
          base_image="blue.svg"
          break;
      case 1: //yellow
          base_image="yellow.svg"
          break;
      case 2: //red
          base_image="red.svg"
          break;
      case 3: // joker
          base_image="joker.svg"
          break;
      case 4: // neutral
          base_image="neutral.svg"
          break;
      }
      cardValue.text = gameScene.deck.levelLit[level]
      cardImage.source = "../../assets/cards/" + base_image

    }
  }
  Behavior on x {

             NumberAnimation {
                 //This specifies how long the animation takes
                 duration: 500
                 //This selects an easing curve to interpolate with, the default is Easing.Linear
                 //easing.type: Easing.OutBounce
             }
         }
  Behavior on y {

             NumberAnimation {
                 //This specifies how long the animation takes
                 duration: 500
                 //This selects an easing curve to interpolate with, the default is Easing.Linear
                 //easing.type: Easing.OutBounce
             }
         }


}
