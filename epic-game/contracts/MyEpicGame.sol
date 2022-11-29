// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract MyEpicGame {
  // キャラクターのデータを格納する CharacterAttributes 型の構造体('struct')を作成しています
  struct CharacterAttributes {
    uint characterIndex;
    string name;
    string imageURI;
    uint hp;
    uint maxHp;
    uint attackDamage;
  }

  // キャラクターのデフォルトデータを保持するための配列 defaultCharacters を作成します。それぞれの配列は、CharacterAttributes 型です。
  CharacterAttributes[] defaultCharacters;

  constructor(
    // プレイヤーが新しく NFT キャラクターをMintする際に、キャラクターを初期化するために渡されるデータを設定しています。これらの値はフロントエンドから渡されます
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterHp,
    uint[] memory characterAttackDmg
  ) {
    // ゲームで扱うすべてのキャラクターをループ処理で呼び出し、それぞれのキャラクターに付与されるデフォルト値をコントラクトに保存する。
    // 後でNFTを作成する際に使用する
    for(uint i = 0; i < characterNames.length; i += 1) {
      defaultCharacters.push(CharacterAttributes({
        characterIndex: i,
        name: characterNames[i],
        imageURI: characterImageURIs[i],
        hp: characterHp[i],
        maxHp: characterHp[i],
        attackDamage: characterAttackDmg[i]
      }));
      CharacterAttributes memory character = defaultCharacters[i];
      console.log("Done initializing %s w/ HP %s, img %s", character.name, character.hp, character.imageURI);
    }
  }
}