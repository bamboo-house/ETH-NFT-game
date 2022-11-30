// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract MyEpicGame is ERC721 {
  // キャラクターのデータを格納する CharacterAttributes 型の構造体('struct')を作成しています
  struct CharacterAttributes {
    uint characterIndex;
    string name;
    string imageURI;
    uint hp;
    uint maxHp;
    uint attackDamage;
  }

  // tokenIdsを簡単に追跡するライブラリを呼び出す
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // キャラクターのデフォルトデータを保持するための配列 defaultCharacters を作成します。それぞれの配列は、CharacterAttributes 型です。
  CharacterAttributes[] defaultCharacters;

  // NFTのtokenIdとCharacterAttributesを紐付ける
  mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

  // ユーザーのアドレスとNFTのtokenIdを紐づける
  mapping(address => uint256) public nftHolders;

  constructor(
    // プレイヤーが新しく NFT キャラクターをMintする際に、キャラクターを初期化するために渡されるデータを設定しています。これらの値はフロントエンドから渡されます
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterHp,
    uint[] memory characterAttackDmg
  ) ERC721("OnePiece", "ONEPIECE") {
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

    // 次のNFTのためにカウンターをインクリメントする
    _tokenIds.increment();
  }

  // ユーザーは mintCharacterNFT 関数を呼び出した、NFTをMintすることができる
  // _characterIndexはフロントエンドから送信される
  function mintCharacterNFT(uint _characterIndex) external {
    uint256 newItemId = _tokenIds.current();

    // msg.sender でフロントエンドからユーザーのアドレスを取得して、NFTをユーザーにMintする
    _safeMint(msg.sender, newItemId);

    nftHolderAttributes[newItemId] = CharacterAttributes({
      characterIndex: _characterIndex,
      name: defaultCharacters[_characterIndex].name,
      imageURI: defaultCharacters[_characterIndex].imageURI,
      hp: defaultCharacters[_characterIndex].hp,
      maxHp: defaultCharacters[_characterIndex].maxHp,
      attackDamage: defaultCharacters[_characterIndex].attackDamage
    });

    console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

    // NFTの所有者を簡単に確認できるようにする。
    nftHolders[msg.sender] = newItemId;

    _tokenIds.increment();
  }
}