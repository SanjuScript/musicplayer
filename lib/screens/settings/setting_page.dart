import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/ANIMATION/fade_animation.dart';
import 'package:music_player/ANIMATION/scale_animation.dart';
import 'package:music_player/ANIMATION/up_animation.dart';
import 'package:music_player/COLORS/colors.dart';
import 'package:music_player/CONTROLLER/song_controllers.dart';
import 'package:music_player/DATABASE/playlistDb.dart';
import 'package:music_player/DATABASE/storage.dart';
import 'package:music_player/PROVIDER/theme_class_provider.dart';
import 'package:music_player/WIDGETS/dialogues/UTILS/dialogue_utils.dart';
import 'package:music_player/WIDGETS/dialogues/reset_confirmation_dialogue.dart';
import 'package:music_player/screens/removed_songs_ui.dart';
import 'package:music_player/screens/settings/Helper/get_playback_values.dart';
import 'package:music_player/screens/settings/Widgets/color_option.dart';
import 'package:music_player/screens/settings/Widgets/custom_switch.dart';
import 'package:music_player/screens/settings/Widgets/setting_item.dart';
import 'package:music_player/screens/settings/appinfo.dart';
import 'package:music_player/screens/settings/contact_support.dart';
import 'package:music_player/screens/settings/privacy_policy.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'Widgets/seting_selection.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  LoopMode _loopMode = LoopMode.off;
  bool _isShuffle = false;

  @override
  void initState() {
    super.initState();
    _loadRepeatMode();
    _loadShuffleMode();
  }

  Future<void> _loadShuffleMode() async {
    final storedShuffle = await MozStorageManager.readData('shuffleMode');
    setState(() {
      _isShuffle = storedShuffle != null ? storedShuffle == 'true' : false;
    });
  }

  Future<void> _saveShuffleMode(bool isShuffle) async {
    await MozStorageManager.saveData('shuffleMode', isShuffle.toString());
  }

  Future<void> _loadRepeatMode() async {
    final storedMode = await MozStorageManager.readData('repeatMode');
    setState(() {
      _loopMode = storedMode != null
          ? LoopMode.values[int.parse(storedMode)]
          : LoopMode.off;
    });
  }

  Future<void> _saveRepeatMode(LoopMode loopMode) async {
    MozStorageManager.saveData('repeatMode', loopMode.index.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        context.watch<ThemeProvider>().getTheme() == CustomThemes.darkThemeMode;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    const Icon(Icons.settings),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Theme.of(context).cardColor, // Title color
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/logo.jpg',
                      fit: BoxFit.cover,
                      height: 200.0,
                    ),
                  ),
                ],
              ),
            ),
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.apps), // App icon
                onPressed: () {
                  // Handle icon press
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Playback Settings
                      SettingsSection(
                        title: 'Playback Settings',
                        items: [
                          SettingsItem(
                            title: 'Repeat',
                            trailing: StreamBuilder<LoopMode>(
                              stream: MozController.player.loopModeStream,
                              builder: (context, snapshot) {
                                final currentLoopMode =
                                    snapshot.data ?? LoopMode.off;
                                return CustomSwitch(
                                  value: currentLoopMode != LoopMode.off,
                                  onChanged: (value) async {
                                    final newLoopMode =
                                        value ? LoopMode.all : LoopMode.off;
                                    await MozController.player
                                        .setLoopMode(newLoopMode);
                                    await _saveRepeatMode(newLoopMode);
                                  },
                                );
                              },
                            ),
                          ),
                          SettingsItem(
                            title: 'Shuffle',
                            trailing: StreamBuilder<bool>(
                              stream:
                                  MozController.player.shuffleModeEnabledStream,
                              builder: (context, snapshot) {
                                final isShuffle = snapshot.data ?? false;
                                return CustomSwitch(
                                  value: isShuffle,
                                  onChanged: (value) async {
                                    await MozController.player
                                        .setShuffleModeEnabled(value);
                                    await _saveShuffleMode(value);
                                  },
                                );
                              },
                            ),
                          ),
                          SettingsItem(
                            title: 'Playback Speed',
                            trailing: StreamBuilder<double>(
                              stream: MozController.player
                                  .speedStream, // Ensure that this stream exists and is updating
                              builder: (context, snapshot) {
                                // Handle snapshot data and default values
                                double currentSpeed = snapshot.data ?? 1.0;

                                return DropdownButton<String>(
                                  dropdownColor: Theme.of(context).splashColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  style: TextStyle(
                                      color: Theme.of(context).cardColor),
                                  value: GetPlayBackData.getPlaybackSpeedLabel(
                                      currentSpeed), // Use the current speed
                                  items: [
                                    'Normal',
                                    '0.5x',
                                    '0.8x',
                                    '1.0x',
                                    '1.5x',
                                    '2.0x'
                                  ].map((speed) {
                                    return DropdownMenuItem<String>(
                                      value: speed,
                                      child: Text(speed),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    double speedValue =
                                        GetPlayBackData.getPlaybackSpeedValue(
                                            value!);
                                    if (MozController.player.playing) {
                                      MozController.player.setSpeed(speedValue);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          SettingsItem(
                            title: 'Volume',
                            trailing: SizedBox(
                              width: 200.0, // Adjust as needed
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: StreamBuilder<double>(
                                      stream: MozController.player.volumeStream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const CircularProgressIndicator();
                                        }
                                        final volume = snapshot.data!;

                                        return Slider(
                                          value: volume,
                                          min: 0.0,
                                          max: 1.0,
                                          onChanged: (value) {
                                            MozController.player
                                                .setVolume(value);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * .1,
                                    child: StreamBuilder<double>(
                                      stream: MozController.player.volumeStream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Text('0%');
                                        }

                                        final volume = snapshot.data!;
                                        final percentage =
                                            (volume * 100).toStringAsFixed(0);
                                        return Text(
                                          '$percentage%',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Theme & Appearance
                      SettingsSection(
                        title: 'Theme & Appearance',
                        items: [
                          SettingsItem(
                            title: 'Theme',
                            trailing: DropdownButton<String>(
                              dropdownColor: Theme.of(context).splashColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              style:
                                  TextStyle(color: Theme.of(context).cardColor),
                              value: context
                                  .watch<ThemeProvider>()
                                  .getDisplayThemeMode(),
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'Light',
                                  child: Text('Light'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Dark',
                                  child: Text('Dark'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'System Default',
                                  child: Text('System Default'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Time-Based',
                                  child: Text('Time-Based'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == 'Light') {
                                  context.read<ThemeProvider>().setLightMode();
                                  context
                                      .read<ThemeProvider>()
                                      .setTimeBasedMode(false);
                                } else if (value == 'Dark') {
                                  context
                                      .read<ThemeProvider>()
                                      .setTimeBasedMode(false);
                                  context.read<ThemeProvider>().setDarkMode();
                                } else if (value == 'System Default') {
                                  context
                                      .read<ThemeProvider>()
                                      .setTimeBasedMode(false);
                                  context.read<ThemeProvider>().setSystemMode();
                                } else if (value == 'Time-Based') {
                                  context
                                      .read<ThemeProvider>()
                                      .setTimeBasedMode(true);
                                }
                              },
                            ),
                          ),
                          SettingsItem(
                            title: 'Enable Time-Based Mode',
                            trailing: CustomSwitch(
                              value:
                                  context.watch<ThemeProvider>().isTimeBased(),
                              onChanged: (value) {
                                context
                                    .read<ThemeProvider>()
                                    .setTimeBasedMode(value);
                              },
                            ),
                          ),
                          // SettingsItem(
                          //   title: 'Accent Color',
                          //   trailing: const Icon(Icons.color_lens),
                          //   onTap: () {
                          //     if (!isDarkMode) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //       content: Text(
                          //           'switch to dark mode to use this')),
                          // );
                          // HapticFeedback.mediumImpact();
                          //     } else {
                          //       showDialog(
                          //         context: context,
                          //         builder: (context) {
                          //           return AlertDialog(
                          //             title: const Text("Select Accent Color"),
                          //             content: Column(
                          //               mainAxisSize: MainAxisSize.min,
                          //               children: [
                          //                 buildColorOption(context, Colors.red),
                          //                 buildColorOption(
                          //                     context, Colors.green),
                          //                 buildColorOption(
                          //                     context, Colors.blue),
                          //                 buildColorOption(
                          //                     context, Colors.yellow),
                          //               ],
                          //             ),
                          //           );
                          //         },
                          //       );
                          //     }
                          //   },
                          // ),
                        ],
                      ),
                      // Notifications
                      SettingsSection(
                        title: 'Notifications',
                        items: [
                          SettingsItem(
                            title: 'Play Notifications',
                            trailing: CustomSwitch(
                              value: true,
                              onChanged: (value) {
                                HapticFeedback.mediumImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Go to app setting to turn off')),
                                );
                              },
                            ),
                          ),
                          SettingsItem(
                            title: 'Update Notifications',
                            trailing: CustomSwitch(
                              value: true,
                              onChanged: (value) {
                                HapticFeedback.mediumImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Go to app setting to turn off'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      // Music Library
                      SettingsSection(
                        title: 'Music Library',
                        items: [
                          SettingsItem(
                            title: 'Scan Audio',
                            trailing: const Icon(Icons.search),
                            onTap: () {},
                          ),
                          SettingsItem(
                            title: 'Storage Location',
                            trailing: const Icon(Icons.storage),
                            onTap: () {
                              // Open storage location selector
                            },
                          ),
                          SettingsItem(
                            title: 'Removed Songs',
                            trailing: const Icon(Icons.music_off),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RemovedSongsPage()));
                            },
                          ),
                        ],
                      ),
                      // Account
                      SettingsSection(
                        title: 'Account',
                        items: [
                          SettingsItem(
                            title: 'Reset',
                            trailing: const Icon(FontAwesomeIcons.eraser),
                            onTap: () {
                              DialogueUtils.getDialogue(context, 'reset');
                            },
                          ),
                        ],
                      ),
                      // Help & Support
                      SettingsSection(
                        title: 'Help & Support',
                        items: [
                          SettingsItem(
                            title: 'FAQ',
                            trailing: const Icon(Icons.help_outline),
                            onTap: () {
                              Navigator.push(context,
                                  Uptransition(const PrivacyPolicyPage()));
                            },
                          ),
                          SettingsItem(
                            title: 'Contact Support',
                            trailing: const Icon(Icons.contact_support),
                            onTap: () {
                              Navigator.push(context,
                                  Uptransition(const ContactSupportPage()));
                            },
                          ),
                          SettingsItem(
                            title: 'App Info',
                            trailing: const Icon(Icons.info_outline),
                            onTap: () {
                              Navigator.push(
                                  context, Uptransition(const AppInfoPage()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
