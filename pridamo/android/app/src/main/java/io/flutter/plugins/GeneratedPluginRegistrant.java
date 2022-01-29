package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
    flutterEngine.getPlugins().add(new com.example.appsettings.AppSettingsPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.connectivity.ConnectivityPlugin());
    flutterEngine.getPlugins().add(new com.mr.flutter.plugin.filepicker.FilePickerPlugin());
      com.kasem.flutter_absolute_path.FlutterAbsolutePathPlugin.registerWith(shimPluginRegistry.registrarFor("com.kasem.flutter_absolute_path.FlutterAbsolutePathPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin());
    flutterEngine.getPlugins().add(new io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin());
    flutterEngine.getPlugins().add(new com.lyokone.location.LocationPlugin());
    flutterEngine.getPlugins().add(new com.vitanov.multiimagepicker.MultiImagePickerPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.share.SharePlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    flutterEngine.getPlugins().add(new com.csdcorp.speech_to_text.SpeechToTextPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.urllauncher.UrlLauncherPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.videoplayer.VideoPlayerPlugin());
  }
}