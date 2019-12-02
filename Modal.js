

import PropTypes from 'prop-types';
import React from 'react';
import {
  ScrollView,
  StyleSheet,
  View,
  Platform,
  Modal,
} from 'react-native';
import AppContainer from 'react-native/Libraries/ReactNative/AppContainer';
import RNTModalHostView from './RNTModalHostViewNativeComponent';

/**
 * The Modal component is a simple way to present content above an enclosing view.
 *
 * See https://facebook.github.io/react-native/docs/modal.html
 */

// In order to route onDismiss callbacks, we need to uniquely identifier each
// <Modal> on screen. There can be different ones, either nested or as siblings.
// We cannot pass the onDismiss callback to native as the view will be
// destroyed before the callback is fired.
/* eslint-disable */
let uniqueModalIdentifier = 0;
class iOSModal extends React.Component {
  static defaultProps = {
    visible: true,
    hardwareAccelerated: false,
  };

  static contextTypes = {
    rootTag: PropTypes.number,
  };

  constructor(props: Props) {
    super(props);
    Modal._confirmProps(props);
    this._identifier = uniqueModalIdentifier++;
  }

  static childContextTypes = {
    virtualizedList: PropTypes.object,
  };

  getChildContext() {
    // Reset the context so VirtualizedList doesn't get confused by nesting
    // in the React tree that doesn't reflect the native component hierarchy.
    return {
      virtualizedList: null,
    };
  }

  componentWillUnmount() {
    if (this.props.onDismiss != null) {
      this.props.onDismiss();
    }
  }

  UNSAFE_componentWillReceiveProps(nextProps) {
    Modal._confirmProps(nextProps);
  }

  static _confirmProps(props) {
    if (
      props.presentationStyle
      && props.presentationStyle !== 'overFullScreen'
      && props.transparent
    ) {
      console.warn(
        `Modal with '${
          props.presentationStyle
        }' presentation style and 'transparent' value is not supported.`,
      );
    }
  }

  // We don't want any responder events bubbling out of the modal.
  _shouldSetResponder() {
    return true;
  }

  render() {
    if (this.props.visible !== true) {
      return null;
    }

    const containerStyles = {
      backgroundColor: this.props.transparent ? 'transparent' : 'white',
    };

    let { animationType } = this.props;
    if (!animationType) {
      // manually setting default prop here to keep support for the deprecated 'animated' prop
      animationType = 'none';
      if (this.props.animated) {
        animationType = 'slide';
      }
    }

    let { presentationStyle } = this.props;
    if (!presentationStyle) {
      presentationStyle = 'fullScreen';
      if (this.props.transparent) {
        presentationStyle = 'overFullScreen';
      }
    }

    const innerChildren = __DEV__ ? (
      <AppContainer rootTag={this.context.rootTag}>
        {this.props.children}
      </AppContainer>
    ) : (
      this.props.children
    );

    return (
      <RNTModalHostView
        animationType={animationType}
        presentationStyle={presentationStyle}
        transparent={this.props.transparent}
        hardwareAccelerated={this.props.hardwareAccelerated}
        onRequestClose={this.props.onRequestClose}
        onDismiss={this.props.onDismiss}
        onShow={this.props.onShow}
        statusBarTranslucent={this.props.statusBarTranslucent}
        identifier={this._identifier}
        style={styles.modal}
        onStartShouldSetResponder={this._shouldSetResponder}
        supportedOrientations={this.props.supportedOrientations}
        onOrientationChange={this.props.onOrientationChange}
      >
        <ScrollView.Context.Provider value={null}>
          <View style={[styles.container, containerStyles]}>
            {innerChildren}
          </View>
        </ScrollView.Context.Provider>
      </RNTModalHostView>
    );
  }
}

const styles = StyleSheet.create({
  modal: {
    position: 'absolute',
  },
  container: {
    right: 0,
    left: 0,
    top: 0,
    flex: 1,
  },
});

if (Platform.OS === 'android') {
  module.exports = Modal;
} else {
  module.exports = iOSModal;
}
