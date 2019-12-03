
# react-native-modal-patch

## Getting started

`$ yarn add https://github.com/HarvestProfit/react-native-modal-patch.git

### Install

`cd ios && pod install`

## Usage

This is the same API as the react native modal https://facebook.github.io/react-native/docs/modal#docsNav.

```javascript
import Modal from 'react-native-modal-patch';

//....
render() {
  return (
    <Modal
      animationType="slide"
      presentationStyle="pageSheet" // <-- Swipe down/dismiss works now!
      visible={this.state.modalVisible}
      onDismiss={() => this.setModalVisible(false)} // <-- This gets called all the time
    >
      {/* modal contents */}
    </Modal>
  );
  
```
