//
//  UserInfoViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 09.09.2022.
//

import UIKit
import FirebaseAuth

final class UserInfoViewController: UIViewController {
    
    let titleLabel = UILabel(text: "Tell us about yourself", font: .robotoMedium(size: 20), color: .black)
    
    let backgroundSliceOne = UIImageView(image: #imageLiteral(resourceName: "background_slice1"), contentMode: .center)
    let backgroundSliceTwo = UIImageView(image: #imageLiteral(resourceName: "background_slice2"), contentMode: .center)
    
    let addPhotoDelegate = AddPhotoView()
    let addPhotoButton = UIButton(title: "Add photo", titleColor: #colorLiteral(red: 0.5593468547, green: 0.5593467951, blue: 0.5593468547, alpha: 1), backgroundColor: .clear, font: .robotoMedium(size: 16), isShadow: false, cornerRadius: 0)
    
    let nameLabel = UILabel(text: "Name", font: .robotoRegular(size: 14), color: #colorLiteral(red: 0.5593468547, green: 0.5593467951, blue: 0.5593468547, alpha: 1))
    let aboutMeLabel = UILabel(text: "About you", font: .robotoRegular(size: 14), color: #colorLiteral(red: 0.5593468547, green: 0.5593467951, blue: 0.5593468547, alpha: 1))
    let countryLabel = UILabel(text: "Select country", font: .robotoRegular(size: 14), color: #colorLiteral(red: 0.5593468547, green: 0.5593467951, blue: 0.5593468547, alpha: 1))
    let birthdayLabel = UILabel(text: "Date of birthday", font: .robotoRegular(size: 14), color: #colorLiteral(red: 0.5593468547, green: 0.5593467951, blue: 0.5593468547, alpha: 1))
    
    let nameTextField = OneTextField(textColor: .black, font: .robotoRegular(size: 15))
    let aboutYouTextField = OneTextField(textColor: .black, font: .robotoRegular(size: 15))
    let countryTextField = OneTextField(textColor: .black, font: .robotoRegular(size: 15))
    let birthdayTextField = OneTextField(textColor: .black, font: .robotoRegular(size: 15))
    
    let countryButton = UIButton(title: "Select country", titleColor: #colorLiteral(red: 0.5593468547, green: 0.5593467951, blue: 0.5593468547, alpha: 1), backgroundColor: .clear, font: .robotoMedium(size: 16), isShadow: false, cornerRadius: 0)
    
    let datePicker = UIDatePicker()
    
    let selectGender = UISegmentedControl(first: "Male", second: "Female", tintColor: .white, selectedSegmentTintColor: .white)
    let saveButton = UIButton(title: "Save", titleColor: .white, backgroundColor: #colorLiteral(red: 0.3411764706, green: 0.2862745098, blue: 0.8823529412, alpha: 1), font: .robotoMedium(size: 16), isShadow: false, cornerRadius: 10)
    
    let currentUser: User

    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
        didButtonTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSubViews()
        setupDatePicker()
    }
    
    func didButtonTap() {
        addPhotoButton.addTarget(self, action: #selector(setImageButtonTap), for: .touchUpInside)
        countryButton.addTarget(self, action: #selector(countryButtonTap), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
    }
    
    @objc private func setImageButtonTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func countryButtonTap() {
        navigationController?.pushViewController(CountryPickerViewController(currentUser: currentUser), animated: true)
    }

    @objc private func saveButtonTap() {
        FireStoreService.shared.saveUserInfo(id: currentUser.uid,
                                             email: currentUser.email!,
                                             userImage: addPhotoDelegate.imageView.image,
                                             username: nameTextField.text!,
                                             description: aboutYouTextField.text!,
                                             gender: selectGender.titleForSegment(at: selectGender.selectedSegmentIndex)) { result in
            switch result {
            case .success(let messangerUser):
                let tabBar = TabBarViewController(currentUser: messangerUser)
                tabBar.modalPresentationStyle = .fullScreen
                self.present(tabBar, animated: true)
                self.showAlert(title: "Completed", message: "")
                print(messangerUser.email)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChange), for: UIControl.Event.valueChanged)
        datePicker.tintColor = #colorLiteral(red: 0.3411764706, green: 0.2862745098, blue: 0.8823529412, alpha: 1)
        
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateChange))
//        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        toolBar.setItems([flex,doneButton], animated: true)
//        birthdayTextField.inputAccessoryView = toolBar
        //        datePicker.frame.size = CGSize(width: 0, height: 250)
//
//        toolBar.barTintColor = .systemBackground
//        toolBar.tintColor = #colorLiteral(red: 0.3403419256, green: 0.2859731317, blue: 0.8841039538, alpha: 1)
    }
    
    @objc private func dateChange() {
        dateFormat()
        view.endEditing(true)
    }
    
    private func dateFormat() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
//        birthdayTextField.text = formatter.string(from: datePicker.date)
    }
}

extension UserInfoViewController {
    
    private func setupSubViews() {
        view.backgroundColor = .white
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupDatePicker()
    }
    
    private func addConstraints() {
        let nameStackView = UIStackView(arrangedSubViews: [nameLabel,nameTextField], axis: .vertical, spacing: 20)
        let descriptionStackView = UIStackView(arrangedSubViews: [aboutMeLabel,aboutYouTextField], axis: .vertical, spacing: 20)
        let birthdayStackView = UIStackView(arrangedSubViews: [birthdayLabel,datePicker], axis: .horizontal, spacing: 20)
        
        let centerStackView = UIStackView(arrangedSubViews: [nameStackView,descriptionStackView,selectGender,countryButton,birthdayStackView], axis: .vertical, spacing: 30)
        
        view.addSubview(backgroundSliceOne)
        view.addSubview(backgroundSliceTwo)
        view.addSubview(titleLabel)
        view.addSubview(addPhotoDelegate)
        view.addSubview(addPhotoButton)
        view.addSubview(centerStackView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoDelegate.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            addPhotoDelegate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            addPhotoButton.topAnchor.constraint(equalTo: addPhotoDelegate.bottomAnchor, constant: 15),
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            centerStackView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 20),
            centerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            centerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            centerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            selectGender.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: centerStackView.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            backgroundSliceOne.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundSliceOne.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundSliceTwo.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundSliceTwo.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
}

extension UserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        addPhotoDelegate.imageView.image = image
    }
}
