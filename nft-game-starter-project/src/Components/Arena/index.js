import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import { CONTRACT_ADDRESS, transformCharacterData } from "../../constants";
import myEpicGame from "../../utils/MyEpicGame.json";
import "./Arena.css";
// フロントエンドにNFTキャラクターを表示するため、characterNFTのメタデータを渡します。
const Arena = ({ characterNFT }) => {
  // コントラクトのデータを保有する状態変数を初期化します。
  const [gameContract, setGameContract] = useState(null);
  const [boss, setBoss] = useState(null);

  // ページがロードされると下記が実行されます。
  useEffect(() => {
    const { ethereum } = window;
    if (ethereum) {
      const provider = new ethers.providers.Web3Provider(ethereum);
      const signer = provider.getSigner();
      const gameContract = new ethers.Contract(
        CONTRACT_ADDRESS,
        myEpicGame.abi,
        signer
      );
      setGameContract(gameContract);
    } else {
      console.log("Ethereum object not found");
    }
  }, []);

  useEffect(() => {
    const fetchBoss = async () => {
      const bossTxn = await gameContract.getBigBoss();
      console.log("Boss:", bossTxn);
      setBoss(transformCharacterData(bossTxn));
    };

    if (gameContract) {
      fetchBoss();
    }
  }, [gameContract]);


  return (
    <div className="arena-container">
      {/* ボス */}
      <p>ボスを表示します。</p>
      {/* NFT キャラクター */}
      <p>NFT キャラクターを表示します。</p>
    </div>
  );
};
export default Arena;